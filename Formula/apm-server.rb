class ApmServer < Formula
  desc "Server for shipping APM metrics to Elasticsearch"
  homepage "https://www.elastic.co/"
  url "https://github.com/elastic/apm-server/archive/v6.2.2.tar.gz"
  sha256 "b0ad1b5b693b4088bc305c0e3086878fafe958bfc7a3300ade9b37a5930c2a37"
  head "https://github.com/elastic/apm-server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8639141ada4ec2e951753e3ac155e60a324e9f5db9d24d9c43ecf1ae54967910" => :high_sierra
    sha256 "992834bb1171ed580342946cce40eb0dea03dc4c9a9945e5974c549d10e05ffe" => :sierra
    sha256 "7dfd0bc26f21ea998c7825d9f56eeae8d0aa0acc8760b4b55aae60fae5c1b6d8" => :el_capitan
  end

  depends_on "go" => :build

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/d4/0c/9840c08189e030873387a73b90ada981885010dd9aea134d6de30cd24cb8/virtualenv-15.1.0.tar.gz"
    sha256 "02f8102c2436bb03b3ee6dede1919d1dac8a427541652e5ec95171ec8adbc93a"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elastic/apm-server").install buildpath.children

    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python2.7/site-packages"

    resource("virtualenv").stage do
      system "python", *Language::Python.setup_install_args(buildpath/"vendor")
    end

    ENV.prepend_path "PATH", buildpath/"vendor/bin"

    cd "src/github.com/elastic/apm-server" do
      system "make"
      system "make", "update"
      (libexec/"bin").install "apm-server"
      libexec.install "_meta/kibana"

      (etc/"apm-server").install Dir["apm-server*.yml"]
      (etc/"apm-server").install "fields.yml"
      prefix.install_metafiles
    end

    (bin/"apm-server").write <<~EOS
      #!/bin/sh
        exec #{libexec}/bin/apm-server \
        -path.config #{etc}/apm-server \
        -path.home #{libexec} \
        -path.logs #{var}/log/apm-server \
        -path.data #{var}/lib/apm-server \
        "$@"
    EOS
  end

  def post_install
    (var/"lib/apm-server").mkpath
    (var/"log/apm-server").mkpath
  end

  plist_options :manual => "apm-server"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_bin}/apm-server</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    require "socket"

    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    (testpath/"config/apm-server.yml").write <<~EOS
      apm-server:
        host: localhost:#{port}
      output.file:
        path: "#{testpath}/apm-server"
        filename: apm-server
        codec.format:
          string: '%{[transaction]}'
    EOS
    pid = fork do
      exec bin/"apm-server", "-path.config", testpath/"config", "-path.data", testpath/"data"
    end
    sleep 1

    begin
      system "curl", "-H", "Content-Type: application/json", "-XPOST", "localhost:#{port}/v1/transactions", "-d",
             '{"service":{"name":"app1","agent":{"name":"python","version":"1.0"}},' \
             '"transactions":[{"id":"945254c5-67a5-417e-8a4e-aa29efcbfb79","name":"GET /api/types","type":"request","duration":32.592981,"timestamp":"2017-05-09T15:04:05.999999Z"}]}'
      sleep 1
      s = (testpath/"apm-server/apm-server").read
      assert_match "\"id\":\"945254c5-67a5-417e-8a4e-aa29efcbfb79\"", s
      assert_match "\"name\":\"GET /api/types\"", s
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
