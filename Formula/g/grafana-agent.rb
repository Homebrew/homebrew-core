class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "0c2ecd12460ee8549ed42ad9a4d02a4824fb08b93527a393e0bdc5d43e16ab9a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c772e86233e1247ab673c7c9b2f69ee052db8b2b9b44d4c441ec0643458d717"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51f42a3410adb0bfe9c5d7f69c20894238f40ee03a4edaf3fdeaf9adb6930da9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3486ec0d2a9158e259b7896bba2cad98db25f540d1146222b99ee55da724468"
    sha256 cellar: :any_skip_relocation, ventura:        "fd6617a9c09fb9a405c3e1e45bd283c78527e11a3febab3ebb765b4202adb01c"
    sha256 cellar: :any_skip_relocation, monterey:       "a391d365d2e61ebd4824cd6336ea64dc76c61255c99d551d8703a94551ad54ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "356ed74733ae74bba2dee517956c5b944f2824e7043124d8c57fc9943896dd1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a40ee9c90696ced0a543e5a33a103d2538db80d4e40af0a728ffad038b27ae91"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  on_linux do
    depends_on "systemd" => :build
  end

  def install
    ldflags = %W[
      -X github.com/grafana/agent/pkg/build.Branch=HEAD
      -X github.com/grafana/agent/pkg/build.Version=v#{version}
      -X github.com/grafana/agent/pkg/build.BuildUser=#{tap.user}
      -X github.com/grafana/agent/pkg/build.BuildDate=#{time.iso8601}
    ]
    args = std_go_args(ldflags: ldflags) + %w[-tags=builtinassets,noebpf]

    # Build the UI, which is baked into the final binary when the builtinassets
    # tag is set.
    cd "web/ui" do
      system "yarn"
      system "yarn", "run", "build"
    end

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
