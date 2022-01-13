class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "d941335c83308e38afbec46f2d93082ac51cdfa6b975c0faaf2998aa938c3160"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "965486f37a35f04a044b90ac1f08da9bcb55b4bbf331b58b39d742958e93ad1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a929231267626974a92ed4dad3bd832a8e333ca5c552c509644724b534fdd47"
    sha256 cellar: :any_skip_relocation, monterey:       "6dfc863d09d4f7eeb3235d2f5f83e0d6ae32815d6f9171a1499be3abc0b5158d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc5013df72b19400084621faba202363952aa4e12148461959735676762f1d9d"
    sha256 cellar: :any_skip_relocation, catalina:       "392fb5b5a8c60118e9aacc205d7f77625cead5e939f8daf474c94af0ffe09957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caef53f6302308ab644285e538954b5dbc6e7e5b073c0217ff55b1266d5ef834"
  end

  depends_on "go" => :build

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
