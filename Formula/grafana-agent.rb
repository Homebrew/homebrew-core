class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "da23573532abdf62f02265f78d1c8ea0a758c9fb69e1772a1a2716532f454e0e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04f83b1ab521b1483e11abe376d1ee3d3b310cbfc5a56aaa66a9f8d16a0a1ace"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8575c1158f73508cf1345dbd1913873aefb09eb1767ca864456241b8d7a6f9bb"
    sha256 cellar: :any_skip_relocation, monterey:       "4bc5393999066ddff55f8ad8fb8c011b8faa8de25dec1957a84c63249e074852"
    sha256 cellar: :any_skip_relocation, big_sur:        "43b840467cdd62c34c22516c07eb371a5647aa39f4ea9d5221bbc37481d93b82"
    sha256 cellar: :any_skip_relocation, catalina:       "a25beb6b0697134b2a214d0d108453e371d4f09c871a07bfe039e64f74e4418b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fc4f3db8fb714ed58afc3da72c5d6f51ffc15e2c5f1c7e6c2830c7aae260219"
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
        "-metrics.wal-directory=#{testpath}/wal"
    end
    sleep 10

    output = shell_output("curl -s 127.0.0.1:#{port}/metrics")
    assert_match "agent_build_info", output
  end
end
