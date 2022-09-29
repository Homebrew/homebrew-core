class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/v0.28.0.tar.gz"
  sha256 "094b5bb33931649a5db0ee233c0055eb464f10d5c7db7004607d9afb16c7f449"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4aac40f5dad15a89a7bdd38a431c3e1f06899b99a25d4bcb9a1e21782740d585"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9ca960dc728f1442e7b8392ea9595d2239a14fb16e27508df808c21d4aaeb04"
    sha256 cellar: :any_skip_relocation, monterey:       "65171ed917395737c934de7d7d99e561754dcd872888f2e029ed7dea053cb662"
    sha256 cellar: :any_skip_relocation, big_sur:        "89f0d9bd5d43388300bcf64ca2214327a6b0670a967724497eff7bb934ee5c32"
    sha256 cellar: :any_skip_relocation, catalina:       "5628cff8c477eb379efb75992b3179e84f2b62e7a18e0a705dcbf9f0272526e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f0fbce38a5cf2a32fbea5d100c528da63d718d0b60450355d856ac9d67bb8c1"
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
