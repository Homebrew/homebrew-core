class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "0de47be2e96fff1ddf55de6f53bff301a55b3a142af40bfb934c8c8b5189e9b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bab099008ea51ea316dd70c4d9673ac7eab6149dd3b9c62ab198b8ca7df15880"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39da596276b4d240e46c36ac0664942270c82dcfdc64ef590c4b2ceefcf46404"
    sha256 cellar: :any_skip_relocation, monterey:       "c97b0730792eabdf17b2812e5577e354f52165b7abf3790f82fa4afc7a084ec7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2aaf8f39bf8239f5a633fe4520cbcacfa0dfd35f375904de27610ceff925d51b"
    sha256 cellar: :any_skip_relocation, catalina:       "cdb94c433986171f0eddf729c2f1ca94a888d9bab4241cd7c740f424cd310f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cda0a043d29204e87815f0003cbc8f6082b0834aacb59e4fd84fd836bccb9fdf"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  on_linux do
    depends_on "systemd" => :build
  end

  def install
    ldflags = %W[
      -X github.com/grafana/agent/pkg/build.Branch=HEAD
      -X github.com/grafana/agent/pkg/build.Version=v#{version}
      -X github.com/grafana/agent/pkg/build.BuildUser=#{tap.user}
      -X github.com/grafana/agent/pkg/build.BuildDate=#{time.rfc3339}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "./cmd/agent"
    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "-o", bin/"grafana-agentctl", "./cmd/agentctl"
  end

  def post_install
    (etc/"grafana-agent").mkpath
  end

  def caveats
    <<~EOS
      The agent uses a configuration file that you must customize before running:
        #{etc}/grafana-agent/config.yml
    EOS
  end

  service do
    run [opt_bin/"grafana-agent", "-config.file", etc/"grafana-agent/config.yml"]
    keep_alive true
    log_path var/"log/grafana-agent.log"
    error_log_path var/"log/grafana-agent.err.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grafana-agent --version")
    assert_match version.to_s, shell_output("#{bin}/grafana-agentctl --version")

    port = free_port

    (testpath/"wal").mkpath

    (testpath/"grafana-agent.yaml").write <<~EOS
      server:
        log_level: info
        http_listen_port: #{port}
        grpc_listen_port: #{free_port}
    EOS

    system "#{bin}/grafana-agentctl", "config-check", "#{testpath}/grafana-agent.yaml"

    fork do
      exec bin/"grafana-agent", "-config.file=#{testpath}/grafana-agent.yaml",
        "-prometheus.wal-directory=#{testpath}/wal"
    end
    sleep 10

    output = shell_output("curl -s 127.0.0.1:#{port}/metrics")
    assert_match "agent_build_info", output
  end
end
