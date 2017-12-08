class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/products/beats/heartbeat"
  url "https://github.com/elastic/beats/archive/v6.0.1.tar.gz"
  sha256 "10cbac9789b227e844ad47ef563266057f5b7f6ca58d480f46c966e5055694ce"
  head "https://github.com/elastic/beats.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b45593df06d6357e4903f35289a929996870b5d684185501d708ceff8ab3ed3" => :high_sierra
    sha256 "88e5206e04aac99fd3b04435f0cf5a17f9e49b73725c8b001f1dc5c9f56328b8" => :sierra
    sha256 "e58bfac4745b0fa66e4d660b8ced0da5707107ecb2d62f978e2baf024e5640c2" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elastic/beats").install buildpath.children

    cd "src/github.com/elastic/beats/heartbeat" do
      system "make"
      (libexec/"bin").install "heartbeat"
      libexec.install "_meta/kibana"

      (etc/"heartbeat").install Dir["heartbeat*.{json,yml}"]
      prefix.install_metafiles
    end

    (bin/"heartbeat").write <<~EOS
      #!/bin/sh
        exec #{libexec}/bin/heartbeat \
        -path.config #{etc}/heartbeat \
        -path.home #{libexec} \
        -path.logs #{var}/log/heartbeat \
        -path.data #{var}/lib/heartbeat \
        "$@"
    EOS
  end

  def post_install
    (var/"lib/heartbeat").mkpath
    (var/"log/heartbeat").mkpath
  end

  plist_options :manual => "heartbeat"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_bin}/heartbeat</string>
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

    (testpath/"config/heartbeat.yml").write <<~EOS
      heartbeat.monitors:
      - type: tcp
        schedule: '@every 5s'
        hosts: ["localhost:#{port}"]
        check.send: "hello\\n"
        check.receive: "goodbye\\n"
      output.file:
        path: "#{testpath}/heartbeat"
        filename: heartbeat
        codec.format:
          string: '%{[monitor]}'
    EOS
    pid = fork do
      exec bin/"heartbeat", "-path.config", testpath/"config", "-path.data",
                            testpath/"data"
    end
    sleep 5

    begin
      assert_match "hello", pipe_output("nc -c -l #{port}", "goodbye\n", 0)
      sleep 5
      assert_match "\"status\":\"up\"", (testpath/"heartbeat/heartbeat").read
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
