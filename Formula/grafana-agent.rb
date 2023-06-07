class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "95139c7e7f5bbb12fa1985e9ed9547ae5cc8c2a8de5d45d8e842082cd7307ff2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "952c98f672fe0fadf7608fe822685a333e190340e2044bba654213a6fd47ebe4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1321e7ad5f26e0859616af986c694720767eacd21756d98132187f8ef1726f5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0dd1f42346dc2e4c3e4fd84d021b2a6f53cdfc0921a9d307facb3b997818239"
    sha256 cellar: :any_skip_relocation, ventura:        "193dc7be4ea6511dbb1645c25a9c41f8397ba27b458b53861dfbf6da6f61e24b"
    sha256 cellar: :any_skip_relocation, monterey:       "f5af5fa0b318b0e97f107356bbb72ccd2cb95657c856abb4612ecdb6c9d2e7c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac92496ac2883ffe2b38930b2d1b30b38dd21f1974ed14c89fb2f55ec95192da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86bb888b515e9ef89d0948f9c088b32c4d684f57846eac051986ff0ea993423b"
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
