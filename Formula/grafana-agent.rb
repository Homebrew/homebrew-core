class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "da23573532abdf62f02265f78d1c8ea0a758c9fb69e1772a1a2716532f454e0e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "220606e85009806dc6d5c861e9b2ef938d9953d62397c3524c9ffba497f96d71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcb27a88c14f65b4739186b2daf0c22eb5951cfba7871aa06b4471830eada621"
    sha256 cellar: :any_skip_relocation, monterey:       "83b6502b2ec4b27f4f6f1178631c8df11ebfbe186b27dac1a05c6ebc7ec333b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "bde75a9fd54c11cf16a206ba8b3ad958437c0930cf806c5643b7e947b379531a"
    sha256 cellar: :any_skip_relocation, catalina:       "927c87ee7cb57c84f916eb47a9b1fbda9cedd33c7826567015cdeb442459d1eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "141e7dd49f9b4a99097b46b5f95e527c960be33646a9c0878c4b4828c9466d82"
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
