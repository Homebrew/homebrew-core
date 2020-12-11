class GrafanaCloudAgent < Formula
  desc "Lightweight subset of Prometheus and more, optimized for Grafana Cloud"
  homepage "https://grafana.com/products/cloud/"
  url "https://github.com/grafana/agent/archive/v0.8.0.tar.gz"
  sha256 "3b8cb72793888f676fb205ced065da173429289dd29c77b79b095350ec28bf35"
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

    bin.install "./cmd/agent/agent"
    mv "#{bin}/agent", "#{bin}/grafana-cloud-agent"

    (bin/"grafana-cloud-agent_brew_services").write <<~EOS
      #!/bin/bash
      exec #{bin}/grafana-cloud-agent $(<#{etc}/grafana-cloud-agent.args)
    EOS

    (buildpath/"grafana-cloud-agent.args").write <<~EOS
      --config.file #{etc}/grafana-cloud-agent.yml
    EOS

    (buildpath/"grafana-cloud-agent.yml").write <<~EOS
      server:
        log_level: info
        http_listen_port: 12345

      prometheus:
        wal_directory: /tmp/agent
        global:
          scrape_interval: 15s

      integrations:
        node_exporter:
          enabled: true
          rootfs_path: /host/root
          sysfs_path: /host/sys
          procfs_path: /host/proc
        prometheus_remote_write:
          - url: https://prometheus-us-central1.grafana.net/api/prom/push
            basic_auth:
              username: USERNAME
              password: PASSWORD
    EOS

    etc.install "grafana-cloud-agent.args", "grafana-cloud-agent.yml"
  end

  def caveats
    <<~EOS
      The agent uses a configuration file that you must customize before running:
        #{etc}/grafana-cloud-agent.yml

      You can find the Configuration file reference at:
        https://github.com/grafana/agent/blob/master/docs/configuration-reference.md

      When run from `brew services`, `grafana-cloud-agent` is run from
      `grafana-cloud-agent_brew_services` and uses the flags in:
         #{etc}/grafana-cloud-agent.args
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
            <string>#{opt_bin}/grafana-cloud-agent_brew_services</string>
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
    begin
      port = free_port

      (testpath/"grafana-cloud-agent.yml").write <<~EOS
        server:
          log_level: info
          http_listen_port: #{port}
          grpc_listen_port: #{free_port}
      EOS

      pid = fork do
        exec bin/"grafana-cloud-agent", "-config.file=#{testpath}/grafana-cloud-agent.yml"
      end
      sleep 3
      
      output = shell_output("curl -s -XGET 127.0.0.1:#{port}/metrics")
      assert_match "agent_build_info", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
