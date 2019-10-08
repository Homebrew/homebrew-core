class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/v0.18.1.tar.gz"
  sha256 "9ddf187c462f2681ab4516410ada0e6f0f03097db6986686795559ea71a07694"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff7b019285ebd031d6985bb06e4300518c9e07f01536ebb5281e4970818cb8a3" => :mojave
    sha256 "1cce732622dee4be305a42090545dfb493513229bbe9dbbd203432d108b4594c" => :high_sierra
    sha256 "8dff90ccbad967c36b51e27e3c681deb8369f417fae3111765f92f847e3bc30b" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/prometheus/node_exporter").install buildpath.children
    cd "src/github.com/prometheus/node_exporter" do
      system "go", "build", "-o", bin/"node_exporter", "-ldflags",
           "-X github.com/prometheus/node_exporter/vendor/github.com/prometheus/common/version.Version=#{version}",
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
