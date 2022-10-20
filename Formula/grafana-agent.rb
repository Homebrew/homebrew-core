class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/v0.28.0.tar.gz"
  sha256 "094b5bb33931649a5db0ee233c0055eb464f10d5c7db7004607d9afb16c7f449"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "374c32af48b6ad8e24fca232fd348b123c6eac9fe8a64651e3c167bf71a4ff24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c32cde09d05a17e70a5e6362502e4c8f1531d2dd095b4db42f860ee5ea3014b0"
    sha256 cellar: :any_skip_relocation, monterey:       "be93cbd90d56e2ac3b870c97b70c84934ddf44976f6f584dfd4ec72612c634a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ca999fc58e99d49142dcf31e77b2ed4dab9de561bc42f3db6b5d7cf00b08757"
    sha256 cellar: :any_skip_relocation, catalina:       "a4da01509c0549df642aa77e5e2c48b1ed7349ec482910dea7b0835be0c9d78d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e1d031c287caea642a4233c7f8c1259013c4817c10089a5ace090b248953bbe"
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
