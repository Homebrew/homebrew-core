class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "244db6a0e47e55a622bf5dfb16d5c06d083217b5c5d1bef2bbc05d14635a3f0f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a7c04c8610e11cbd7c144aecd2140c08ad62696760ce8869d82811b77a26a7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1619a4a254620cc42843666749c150b1d931a30cfd44cf519ea30df41ba40268"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf844d9cf8dd8973bc58769f3342ec773e86fc1e5fd1a727e33801f0fd3b3278"
    sha256 cellar: :any_skip_relocation, ventura:        "b323ce1800df8f1bed342c51d85dd00218941a9f52dd58f2d872bf5e82a4a655"
    sha256 cellar: :any_skip_relocation, monterey:       "99e640def575b5a8acc945569ba2cb64d960ad3cb8081c4420bb471f5d61c952"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4208e7271fdaaa484f4a6bc38439bc64bc4e88d402497059b9ed67358179714"
    sha256 cellar: :any_skip_relocation, catalina:       "2c1cc52cdf7ef169266bd35a37ce5e0b7f80904acbc5580d60a6b816a48a1908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bde64d34d230f9eed071d6ed2eca3ee29b2510bbbe41e4dcba13e37e597ce23"
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
