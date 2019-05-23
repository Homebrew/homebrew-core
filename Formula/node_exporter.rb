class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/v0.18.0.tar.gz"
  sha256 "2f71a4a11fa1388e4a459865520365396f8b6ebbad9d45df476fe60ee0de0415"

  bottle do
    cellar :any_skip_relocation
    sha256 "c051d010b3301d3600f92e90417280710a7336362b981781b0e61dd7e780ecc9" => :mojave
    sha256 "c7f358a38650a8529a9d10a8c38363a810003a0c3e0cfbf354950e24a7a6524a" => :high_sierra
    sha256 "3b08291d087a3f1e8845fb88025b83e73961965be753c35ff3337a00ae37b764" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

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
