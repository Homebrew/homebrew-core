class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.40.4.tar.gz"
  sha256 "0ab8478e7997a307d21fa9a40b61cf76c2ec15b5e5dfb5c401103848cde05caa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "569a160dbe4caf492de404be6c63ada1bca12534b6ba112ffe76547099a982a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "607a755767161c66de691222da2fa021cc5d64115c16018b8c8f344b4235fa3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56462598292ae10fac433823a5ddb2d7d105d6aef6f82036239778ad08456298"
    sha256 cellar: :any_skip_relocation, sonoma:         "587dbe6bbc2b4a60dfc4dc1b31ce622e802584bbd8f6959a978a438097a46631"
    sha256 cellar: :any_skip_relocation, ventura:        "0b4d0d27a4caf103f4191ba65c70aec198b6dffcd2a46d13b06f3aa6e975914a"
    sha256 cellar: :any_skip_relocation, monterey:       "18332b953ac545988959d3404787a664749df528172d3858053aeedfa2e3700e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fce91371033fc466b666c9f04297b7bf7909de458d6ef71d3db09b882c7b8e4d"
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
    args = std_go_args(ldflags:) + %w[-tags=builtinassets,noebpf]

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
