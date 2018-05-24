class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/v0.16.0.tar.gz"
  sha256 "2ed1c1c199e047b1524b49a6662d5969936e81520d6613b8b68cc3effda450cf"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/prometheus").mkpath
    ln_sf buildpath, buildpath/"src/github.com/prometheus/node_exporter"

    system "go", "build", "github.com/prometheus/node_exporter"
    bin.install "node_exporter"
  end

  plist_options :startup => "sudo brew services start node_exporter"

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
          <string>#{opt_bin}/node_exporter $(&lt; #{etc}/node_exporter.args)</string>
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
        <string>#{logs}/err.log</string>
        <key>StandardOutPath</key>
        <string>#{logs}/out.log</string>
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
