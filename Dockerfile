FROM ruby:2.6.5

ENV LANG=C.UTF-8
ENV ENABLE_SERVICE_WORKER=true

WORKDIR /devdocs

RUN apt-get update && \
    apt-get -y install git nodejs libcurl4 && \
    gem install bundler && \
    rm -rf /var/lib/apt/lists/*

RUN cd / && \
    git clone -b master --depth 1 https://github.com/freeCodeCamp/devdocs.git && \
    cd /devdocs && \
    bundle install --system && \
    rm -rf ~/.gem /root/.bundle/cache /usr/local/bundle/cache && \
    thor docs:download --all && \
    thor assets:compile && \
    rm -rf /tmp

EXPOSE 9292
CMD rackup -o 0.0.0.0
