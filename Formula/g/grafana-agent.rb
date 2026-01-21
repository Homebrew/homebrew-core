class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/latest/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.44.4.tar.gz"
  sha256 "ce86302982702912cfe5df98237fd0a3c14b14b1205386b1f5a4b6d3b64cf414"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a073781d8d5c01bb3f630038e0e02aa197d63d5c364924067f15f71b9477d999"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdceb11b537cf0ba0f9f25c13c2dd9807ef4e36e5bedf1cb5901cca082155c16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c787b87e2bddf06935d599e13ec9883fbaaa96ef2a79d525e20139b005e866c"
    sha256 cellar: :any_skip_relocation, sonoma:        "45513ece0e70cc06796d9e6f7b13464f0638a0665d88d335d686e03b8c9ce8d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "294916865ca4acdf865f4e80f78e821e9defd5c69d2a38afd6433eb51c89f17b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be67266b8d9a09438ab69a89cf9719038f9ad63dda94d9f7b0e84b23eb984626"
  end

  # Deprecated upstream though will get security fixes until 2025-10-31.
  # Disable date set 3 months after planned EOL date of 2025-11-01.
  disable! date: "2026-02-01", because: :deprecated_upstream, replacement_formula: "grafana-alloy"

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  on_linux do
    depends_on "systemd" => :build
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/grafana/agent/internal/build.Branch=HEAD
      -X github.com/grafana/agent/internal/build.Version=v#{version}
      -X github.com/grafana/agent/internal/build.BuildUser=#{tap.user}
      -X github.com/grafana/agent/internal/build.BuildDate=#{time.iso8601}
    ]
    args = std_go_args(ldflags:) + %w[-tags=builtinassets,noebpf]

    # Build the UI, which is baked into the final binary when the builtinassets
    # tag is set.
    cd "internal/web/ui" do
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

    (testpath/"grafana-agent.yaml").write <<~YAML
      server:
        log_level: info
    YAML

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
