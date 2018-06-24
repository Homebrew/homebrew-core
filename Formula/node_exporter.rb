class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/v0.16.0.tar.gz"
  sha256 "2ed1c1c199e047b1524b49a6662d5969936e81520d6613b8b68cc3effda450cf"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/prometheus").mkpath
    ln_s buildpath, "src/github.com/prometheus/node_exporter"
    system "go", "build", "-o", bin/"node_exporter", "-ldflags",
           "-X github.com/prometheus/node_exporter/vendor/github.com/prometheus/common/version.Version=#{version}",
           "github.com/prometheus/node_exporter"
  end

  plist_options :manual => "node_exporter"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>sh</string>
          <string>-c</string>
          <string>#{opt_bin}/node_exporter $(&lt; #{etc}/node_exporter.args)</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/node_exporter.err.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/node_exporter.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    output = shell_output("#{bin}/node_exporter --version 2>&1")
    assert_match version.to_s, output
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
