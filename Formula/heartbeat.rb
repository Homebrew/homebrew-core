class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/products/beats/heartbeat"
  url "https://github.com/elastic/beats/archive/v5.6.4.tar.gz"
  sha256 "c06f913af79bb54825483ba0ed4b31752db5784daf3717f53d83b6b12890c0a4"
  revision 1
  head "https://github.com/elastic/beats.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "20986173981fa6f02304c7d26467e732f4e462459242baeec4bdc63f731c94c7" => :high_sierra
    sha256 "1797b8e4893688a81cac01a1d1575856627b8b00d329a5eb4087299c7e251c8b" => :sierra
    sha256 "b34edc1c359c9bbfea92b2abe888ef29dc0da06f0156afeca72c76c3f8ddb460" => :el_capitan
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
          string: '%{[up]}'
    EOS
    pid = fork do
      exec bin/"heartbeat", "-path.config", testpath/"config"
    end
    sleep 1

    begin
      assert_match "hello", pipe_output("nc -c -l #{port}", "goodbye\n", 0)
      sleep 1
      assert_equal "true", (testpath/"heartbeat/heartbeat").read.chomp
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
