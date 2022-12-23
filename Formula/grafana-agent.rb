class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "b631e0fabad9bf3f2d4b7a47143254b3b1b1951d20be3b71afc801ce29893840"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa91ef1a16b4ad60137b5d17cdcdef86cfd7d90f5dcfc0026c8aa147bc9ec7c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dae17e9e01889f6e2203f4ceda717640a3413f2f701a4e5e0a7fe9580e68fec4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8ce4ec0527394b3bb1f6518731533db0818408b2d352e9879161169e29da4b4"
    sha256 cellar: :any_skip_relocation, ventura:        "b0f40e97d30f75fd17c5409ea6f26b9689933f6899b45c96f9e94474e12ff9d9"
    sha256 cellar: :any_skip_relocation, monterey:       "0101251b4e63c7c54bb6214a9148a8157b99e3d67dec0d9accc7f96996c4371e"
    sha256 cellar: :any_skip_relocation, big_sur:        "223bf24110b0476a46374eba1eaf0d1637cf864017252ddd84a71dafb04e60f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8fc584243fd609348ff2c7b1205532b965fa61c1036c3462943a2e29405cdb6"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "systemd" => :build
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/grafana/agent/pkg/build.Branch=HEAD
      -X github.com/grafana/agent/pkg/build.Version=v#{version}
      -X github.com/grafana/agent/pkg/build.BuildUser=#{tap.user}
      -X github.com/grafana/agent/pkg/build.BuildDate=#{time.rfc3339}
    ]
    args = std_go_args(ldflags: ldflags) + %w[-tags=noebpf]

    system "go", "build", *args, "./cmd/agent"
    system "go", "build", *args, "-o", bin/"grafana-agentctl", "./cmd/agentctl"
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
    EOS

    system bin/"grafana-agentctl", "config-check", "#{testpath}/grafana-agent.yaml"

    fork do
      exec bin/"grafana-agent", "-config.file=#{testpath}/grafana-agent.yaml",
        "-metrics.wal-directory=#{testpath}/wal", "-server.http.address=127.0.0.1:#{port}",
        "-server.grpc.address=127.0.0.1:#{free_port}"
    end
    sleep 10

    output = shell_output("curl -s 127.0.0.1:#{port}/metrics")
    assert_match "agent_build_info", output
  end
end
