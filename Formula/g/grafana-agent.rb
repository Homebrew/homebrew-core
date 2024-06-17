class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.41.1.tar.gz"
  sha256 "3b19965df65502155ad73300571548589d2162f49aeebdc713d9b29595b94c14"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "648e3edbc70ca1b6a951f2ac1259c9907da9f1f677bd2967821ee202c125aa76"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df4cf8df8004d8018625257f139e0939a3c902ca94a7004ee5944acafed9c7bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1f3f688f267bdbfc4cb26a3fcd8c4ac6b5f9e75d6d619ad6ab37ea135036fd6"
    sha256 cellar: :any_skip_relocation, sonoma:         "7bc2a2027a51280d3529a0f2845ffe9f9cf6b5307ab095422e4bf676173a487f"
    sha256 cellar: :any_skip_relocation, ventura:        "057e4e0063af4370e8fc59a6e7bc525d9897e77f20c8bdf1ca30ebff39b6a7dd"
    sha256 cellar: :any_skip_relocation, monterey:       "98e3282f5d2567a475f4e71dcd3c70f16aa8e3ea007c478c6f3bc371d82502f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2eeccd57ebbde2c2c01e6445e9d6fbad261d04919da2d310e2e52add96c1c75"
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
