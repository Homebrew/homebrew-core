class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/v0.15.2.tar.gz"
  sha256 "940b850376f94580e88b5e99926d92899975d5792d05709cbd9c48dab0a848ad"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkpath buildpath/"src/github.com/prometheus"
    ln_sf buildpath, buildpath/"src/github.com/prometheus/node_exporter"

    system "make", "build"
    bin.install "node_exporter"
  end

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <!-- See https://github.com/Homebrew/homebrew-services/issues/70 -->
        <key>ProgramArguments</key>
        <array>
          <string>sudo</string>
          <string>-u</string>
          <string>nobody</string>
          <string>sh</string>
          <string>-c</string>
          <string>/usr/local/bin/node_exporter $(&lt; /usr/local/etc/node_exporter.args)</string>
        </array>
        <key>UserName</key>
        <string>nobody</string>
        <key>GroupName</key>
        <string>nobody</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/node_exporter/output.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/node_exporter/output.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    begin
      pid = fork { exec bin/"node_exporter" }
      sleep 2
      assert_match "# HELP", shell_output("curl -s localhost:9100/metrics")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
