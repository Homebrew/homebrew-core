class GrafanaCloudAgent < Formula
  desc "Lightweight subset of Prometheus and more, optimized for Grafana Cloud"
  homepage "https://grafana.com/products/cloud/"
  url "https://github.com/grafana/agent/archive/v0.9.0.tar.gz"
  sha256 "44d872044e0621a77e05f5608ba1bde68e39ddc2aaf0c1c64c53fa3cc7991aa1"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/grafana/agent/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  depends_on "go" => :build

  def install
    mkdir_p buildpath/"src/github.com/grafana"
    ln_sf buildpath, buildpath/"src/github.com/grafana/agent"

    system "make", "agent"

    bin.install "./cmd/agent/agent", "grafana-cloud-agent"
  end

  def post_install
    (etc/"grafana-cloud-agent").mkpath
  end

  def caveats
    <<~EOS
      The agent uses a configuration file that you must customize before running:
        #{etc}/grafana-cloud-agent/config.yml
    EOS
  end

  plist_options manual: "grafana-cloud-agent -config.file=#{HOMEBREW_PREFIX}/etc/grafana-cloud-agent.yml"

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
            <string>#{opt_bin}/grafana-cloud-agent</string>
            <string>-config.file</string>
            <string>#{etc}/grafana-cloud-agent/config.yml</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <false/>
          <key>StandardErrorPath</key>
          <string>#{var}/log/grafana-cloud-agent.err.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/grafana-cloud-agent.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    port = free_port

    (testpath/"grafana-cloud-agent.yml").write <<~EOS
      server:
        log_level: info
        http_listen_port: #{port}
        grpc_listen_port: #{free_port}
    EOS

    fork do
      exec bin/"grafana-cloud-agent", "-config.file=#{testpath}/grafana-cloud-agent.yml"
    end
    sleep 3

    output = shell_output("curl -s -XGET 127.0.0.1:#{port}/metrics")
    assert_match "agent_build_info", output
  end
end
