class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/v0.18.1.tar.gz"
  sha256 "9ddf187c462f2681ab4516410ada0e6f0f03097db6986686795559ea71a07694"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ff1a0c237371d710a60ae7692eb08fa96259840e7565f6345ed50821db2d27aa" => :catalina
    sha256 "9ab6e123c1862749886247564ea64dede482a6cb9efb19c611e2a5a5b4595237" => :mojave
    sha256 "5de4df63394055e449580b4b583f4411237f84096042eef63d3423b39f75ff2e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/prometheus/common/version.Version=#{version}
      -X github.com/prometheus/common/version.BuildUser=Homebrew
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), "-trimpath",
           "-o", bin/"node_exporter"
    prefix.install_metafiles
  end

  def caveats
    <<~EOS
      When used with `brew services`, node_exporter's configuration is stored as command line flags in
        #{etc}/node_exporter.args

      Example configuration:
        echo --web.listen-address :9101 > #{etc}/node_exporter.args

      For the full list of options, execute
        node_exporter -h
    EOS
  end

  plist_options :manual => "node_exporter"

  def plist
    <<~EOS
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
    assert_match /node_exporter/, shell_output("#{bin}/node_exporter --version 2>&1")
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
