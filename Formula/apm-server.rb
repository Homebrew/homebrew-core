class ApmServer < Formula
  desc "Server for shipping APM metrics to Elasticsearch"
  homepage "https://www.elastic.co/"
  url "https://github.com/elastic/apm-server/archive/v6.1.1.tar.gz"
  sha256 "6c3876a889b824d71a18c8905a49d33b940eb69f1f09bd94faba35f3bea8e771"
  head "https://github.com/elastic/apm-server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca79a3f700128d9b5afd0a6de0b60b4190c83ed7ddb2c6af4b5dd74883fc176d" => :high_sierra
    sha256 "7ec37196565464241b5fdaa3ee7ad7b39d89269ae24ffd1d83a3d90bdd2f7b5d" => :sierra
    sha256 "3ea8a38c009092df1772fde14f9beb1385009369fa0dbb8ff41f6baeed457cc0" => :el_capitan
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
             '{"app":{"name":"app1","agent":{"name":"python","version":"1.0"}},' \
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
