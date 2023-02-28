class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "af385fa66fe196fd793b35b9362611d3fdc4df0192f3f29b6a1e48bb6dbfaf43"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "629a35a5c58bfbd1d40167eec9bc2a76053448c755b88e42a4ae5e0ce1cac1c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99fda1983c8212cd6a4e010809c9b772d3f78ea868a2c26319919453aac0d561"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87372730d065abf91cd0a24a2491f3a012dfa2084919c173b3c925a036811441"
    sha256 cellar: :any_skip_relocation, ventura:        "ae13010b4c9420681a7820be00d6653d6a70cc507bc5ee7ff27624cab1005bb9"
    sha256 cellar: :any_skip_relocation, monterey:       "f7312955514ef3cd17414a958773e4946fdea532db0deaa54574aec262ddc1c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9914794581638bba0235105e544e134e397d383b72eb0ba30762344a3f4f045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15abbfdb1b21987578fba78e9bc7bdcf07b0de799b07c3df593ec8e4666f9837"
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
