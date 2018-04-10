class ApmServer < Formula
  desc "Server for shipping APM metrics to Elasticsearch"
  homepage "https://www.elastic.co/"
  url "https://github.com/elastic/apm-server/archive/v6.2.3.tar.gz"
  sha256 "04186e8b3138e878352cf5f1350756caf8e973f510896687aff9560945c7a873"
  head "https://github.com/elastic/apm-server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eef6b08abe500506da842acd3cd0dc2b9efc241f0d9ab8e4219f24852520f989" => :high_sierra
    sha256 "a22163b63538cd7b8d763eaa3447fdecefb32c6d52d368d16acaa74048962402" => :sierra
    sha256 "542a2ee5b87727b51c1887b2f8430bc27a21c4fa314e2b9fd919b2d1a10751ff" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "python@2" => :build

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/b1/72/2d70c5a1de409ceb3a27ff2ec007ecdd5cc52239e7c74990e32af57affe9/virtualenv-15.2.0.tar.gz"
    sha256 "1d7e241b431e7afce47e77f8843a276f652699d1fa4f93b9d8ce0076fd7b0b54"
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
