class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.24.2.tar.gz"
  sha256 "c1657743ed2c3dd7dff1cc3a9777c5b7e950d163d6092cc5159b2198f555fff9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "391170c491e47a14723843d2e6cc8196e7922c863e0ea4f2536b88a872e6e2e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b133d50e590cd4154dde00e0b3e1d768e3014d568054794adc61b75deafb2623"
    sha256 cellar: :any_skip_relocation, monterey:       "f00509727129a9bbf10f0a1332d72aae29c4d21c11967c96dd4ba9df931863c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddd9ecee764d0dabb7ba1571b7aabd604aa9131d9b8e26404687c2e6768b88a6"
    sha256 cellar: :any_skip_relocation, catalina:       "ce5a40b124cde0f308799a972d31ed0308ba7f4b5a50e901a1b5bd0a704ec919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "764157decfd3ee5a02240c4cf27788d36ae51754052b4a0c215b59df04e5cc8f"
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
