class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.40.3.tar.gz"
  sha256 "a3fd909f344e061f3afbda1ccbc928baa9bff63dbc172838bcb861719959e7c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5487b5f764897b58c9199a1c26aa11807ee1ee41f0127f8f64f675631eb0ac05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5ad19e21b5fe27880b0ef13d606522d0d387654d132e45952382d46dae3d267"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03a9ef82afdd10dea2dc4a9c397eee7eb8e9764e56ed54a2a7fcd5abc44295e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e96e21eb5b5851111c3131601fd5a20f55863fdd4510b48492fe673f2418dfa"
    sha256 cellar: :any_skip_relocation, ventura:        "5a06f3b8e69257d0829c929298728150b26ecf651659ae673e5205117ae792f6"
    sha256 cellar: :any_skip_relocation, monterey:       "a834a2aa84ff3eb7bc9bf098f123805118ade7877c1f12cb6d3b1d74269a5612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6deb0d76a5809dd717eb454bbe1406798fc5499fd12d58ceb4cdae63cff899d6"
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
