class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "2b91c3a3e522d79a9375bba806684cb6a9a14eab02613c81a01b8440d5bc7a12"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3195c250163d23058d60dcbd160c7575e7bae6e13d88b940398aa28fdb5d412c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e523ae7f46f5d5c16e6a695ec810a3ce2bb1199e905f9eb2284824932a873a36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45e52d3da1e999a0dc32b724c6418714b235213d905c141fcda47be92e467972"
    sha256 cellar: :any_skip_relocation, ventura:        "3ea4fb5166fdf19548103326b9120774e09a14739cbc82385c6d9514a74d6a9b"
    sha256 cellar: :any_skip_relocation, monterey:       "46577e602d75225cfc41a88884a8ee53fc367dc2db82b111b5acb95b625ddd9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "79a4a64840e26c509fa8b568d636249ed7ad496791aa73fb63a5a35f95a5eb8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04843fcd1bebfd9370f5300e0e7dadafdf00f0e7091a136192a743333713be5f"
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
