class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.40.2.tar.gz"
  sha256 "9ed7f2c0de014277afaa10e1618ff2d75731c229ac83d95986fdd8065838b147"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b11f3617c6ebbce8cd7c12904ece73acb7c4141f6b42e8f1f28a173d2c512567"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "949c320545a842f2c6db12e595ebf156dbcf07ed04487e6039c0d28854d64ba1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83885403e4f420756275128dc2df441c130c9065148fedea59bffae7eaa9d2ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "74458c9f93bf830fb3a10617b3ae81142ace301e5d38bdbcc67f0f795a4f5520"
    sha256 cellar: :any_skip_relocation, ventura:        "10aaa07f21e74823e126e3e48f5d99d54f1f36825baf3dac65e71d019c82e61f"
    sha256 cellar: :any_skip_relocation, monterey:       "13de6d2c58b07c949ee83cd4ebfee8f1d85368b8b54bef550d725350ae420ceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06198c6fd73c77d6576dcd4ddc3844569ad07b2b303c0799fd74ee93ac4750f1"
  end

  depends_on "go@1.21" => :build # use "go" again when https://github.com/grafana/agent/pull/6139 is released
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
