class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/v0.28.1.tar.gz"
  sha256 "1414878c9fec88523c1c9e0a3b2cba70a0128c7d348779d54089c95417fa9e94"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f89d8850b0da12ce73e33e8f8e5c504698e347d9f1bcd1325a85d4d3ebe5ece"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f5aa42d820cf396293e34367fdc39b53f66fe805e9dba230edc997819f1c256"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35ee76e3c1ce8b653076bf8934781bbd17cd6ddef761f5b8058addf08e3039db"
    sha256 cellar: :any_skip_relocation, monterey:       "b35477678749e81604939d705a3b7d0e466a4b61d50394742a464d08fecce1b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "11e74f6fae4e8d5a930f5f0898d3dc070967686ac1297bea214154ad766ebb35"
    sha256 cellar: :any_skip_relocation, catalina:       "233a055bf851a20431600f9d77511fd6e22aef8e4f41228a3c79b3e6a1db2d39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68dfa3a6ee424de29ea91149cc74fffe7777e0b88b11bd49f307255800b640a4"
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
