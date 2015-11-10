FROM ubuntu:14.04

# install some stuff
RUN sudo apt-get update && sudo apt-get install -y nodejs npm nodejs-legacy git git-core wget rpm curl

#ADD src/package.json package.json
#RUN sudo npm install --production

RUN sudo mkdir -p /opt/app

# From here we load our application's code in, therefore the previous docker
# "layer" thats been cached will be used if possible
WORKDIR /opt/app
ADD . /opt/app

# new versions and build numbers can be found at http://www.splunk.com/download/universal-forwarder.html
ENV SPLUNK_FORWARDER_VERSION 6.2.2
ENV SPLUNK_FORWARDER_BUILD 255606
ENV SPLUNK_FORWARDER_DEB_URL https://download.splunk.com/products/splunk/releases/${SPLUNK_FORWARDER_VERSION}/universalforwarder/linux/splunkforwarder-${SPLUNK_FORWARDER_VERSION}-${SPLUNK_FORWARDER_BUILD}-linux-2.6-amd64.deb

# we have to use --insecure since download.splunk.com provides stock Cloudfront certificate with no custom domain
RUN curl --insecure --show-error ${SPLUNK_FORWARDER_DEB_URL} -o splunkforwarder.deb && dpkg -i splunkforwarder.deb && rm splunkforwarder.deb

# change back to original working directory
WORKDIR /opt/app

#RUN pwd

EXPOSE 1200
CMD ["node", "src/app.js"]