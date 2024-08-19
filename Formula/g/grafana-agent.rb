class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "435e4e08ac416a5c9ff87f674b495b218e4adfffa2846799a5ec96053271a85a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7269feef7af6ed5855813d40bc43b379dabaf75c2a6a270adf3b7fd39858eb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be954c277f2f774b8c137e3febb7747e3dd14a43112fd686f65e2ec3dfd30cb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86211f2be8cb5ed9e2445722236401cb32ec60fcbf8bf79df73384a424ec64cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "b07bcafaa9a49f7e2fa78ea012c0e4e56837a8ca20e9ecb389788dbfb6ab5c9c"
    sha256 cellar: :any_skip_relocation, ventura:        "12a9b9db4ede2bbc1aa9dec903e153e71bfb881573d013cc7a5edf5d623de86b"
    sha256 cellar: :any_skip_relocation, monterey:       "4965e850052d847a520a6271072c16545a02747d2f3adcd51ccb1e099b1dc700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9b0c57bcaecc6b5479c42c25a2a183017ed89e6d67f91305517f3a7c180941d"
  end

  # use "go" again when https://github.com/grafana/agent/issues/6972 is resolved and released
  depends_on "go@1.22" => :build
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
