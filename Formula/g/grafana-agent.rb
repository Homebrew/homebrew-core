class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.35.4.tar.gz"
  sha256 "4847360e87bb2c9088f4b629ccfbaa84e424f23fa3442a55f73fc598a779e503"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a830f71a9a00b84b13e5d61cf8972028fad414a396240f5342c4a2fabebdb73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e1cf458aa4b57fbe2f36e25ede7a14f5da4abfeea2fff30ad3b142d35086744"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "905e18e65498ba5e4e9c87e6348c6101ac50812c3e95016a388f9b894ef55651"
    sha256 cellar: :any_skip_relocation, ventura:        "fc31722cb368461f812c1db1a063067b91dd87c544fc21cae2902c3a95b541c7"
    sha256 cellar: :any_skip_relocation, monterey:       "99289aa4dcc95595e3b0a54aefc0975fe01a756ff5087719ca38ddb0647427ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "69c6634b329d01b5d6baf133c3ec8fc4596e036ec01df6f39bca0ef4a91d22a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59197f41f946a6d3a9588f32182aad821b702317180fc6674e5594a4628d47d7"
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
