class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.31.3.tar.gz"
  sha256 "b55218728cbbbc86ca8242d073bfe6297d04314edaeaab7e6b63b69d80ee61a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8d891d8b52cad746e5ae164b44cbfedd55cb2e9e167b83c60bc60a560968c2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae0da929bbbe2575a273480be28b35905a8c759f1614cc18500daf6abb650b23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a172886cd51c347b4fa945b2c594964318806e9e99c6ed902944d565853721f0"
    sha256 cellar: :any_skip_relocation, ventura:        "9b5dde22c3350ef627ce15af8c96270cb36096829f08c51dbcd01c29c04f7868"
    sha256 cellar: :any_skip_relocation, monterey:       "fe04249ab08175aa8bfb41be3206d0d5cefcb79c3aad355515e72787663ec280"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e4001553a8a4c3e6a95e1e3131ccf962d227a6eaeeb9c447553f84d0343a3ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa32bf365b8d8ebf17c1b000f7ca3465cda31418ee6b21da4370ba2fce609427"
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
      -X github.com/grafana/agent/pkg/build.BuildDate=#{time.iso8601}
    ]
    args = std_go_args(ldflags: ldflags) + %w[-tags=noebpf]

    system "go", "build", *args, "./cmd/grafana-agent"
    system "go", "build", *args, "-o", bin/"grafana-agentctl", "./cmd/grafana-agentctl"
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
