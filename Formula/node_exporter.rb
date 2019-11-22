class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/v0.18.1.tar.gz"
  sha256 "9ddf187c462f2681ab4516410ada0e6f0f03097db6986686795559ea71a07694"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "174b28c6400abf9a2c566ea67d0928ad3e49b5a1cf3c1a1b9a813dc19f103094" => :catalina
    sha256 "2cd46fee60f0551f948e81ac31f60184374cba3370a7e1c9dd01b7c55cbd25d3" => :mojave
    sha256 "e5ff3e073b7da6ae318b18b5952525706ac70426f01fd2aea3b4bb53b56ea23d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/prometheus/node_exporter").install buildpath.children
    cd "src/github.com/prometheus/node_exporter" do
      ldflags = %W[
        -X github.com/prometheus/common/version.Version=#{version}
        -X github.com/prometheus/common/version.BuildUser=Homebrew
      ]
      system "go", "build", "-o", bin/"node_exporter",
           "-ldflags", ldflags.join(" "),
           "github.com/prometheus/node_exporter"
      prefix.install_metafiles
    end
  end

  def caveats; <<~EOS
    When used with `brew services`, node_exporter's configuration is stored as command line flags in
      #{etc}/node_exporter.args

    Example configuration:
      echo --web.listen-address :9101 > #{etc}/node_exporter.args

    For the full list of options, execute
      node_exporter -h
  EOS
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
