class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.36.2.tar.gz"
  sha256 "d0af47725ae5e95c6b509d5d60f71c9ff33eb16dd98bf9abc745a0c7fb1cd495"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22c7c52a7ba7c1a889ed9d2b077ac0921d3794785840d3fb7159521707290b82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c197af26b57c96c722b063813a2c1af9ce8c9006d47dc9533eb02a416cecb010"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2c47f5846939443327da9e815344fda105be963b56be1f97620228d480285b5"
    sha256 cellar: :any_skip_relocation, ventura:        "ae1cd2ebda070456d0e5047f1345555f3e727144180cc9b9b0b100891ba1c185"
    sha256 cellar: :any_skip_relocation, monterey:       "81f76ce705f27c3d628630417c968958f11b9c2ebefeefadfb0460c78245c65f"
    sha256 cellar: :any_skip_relocation, big_sur:        "06f9d58f5ad840103bfebc413b391353eac8132a0746c559a9e909f1335c677a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29da83191b1a02184e3bb61284cbfaf16c1d474e0934a8cf848ac51d416a954b"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

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
