class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.31.2.tar.gz"
  sha256 "dea0ad6cfc1be4419ac870462d40a921cece3d7d2c0dd3413fa09aa7dc16f447"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3590b8f588ad84998e23922c4769c1ae68fac48ab83e6fc7737adbc20473e496"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a811124cecc685f52a7f4ccb4ef2057866abdd0e4625ab2ea7e79d84d15ad93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3aad874998f085745e45f3bdb75aa43764eaa71b53cc1eb0807e5d5e5bf8d55d"
    sha256 cellar: :any_skip_relocation, ventura:        "3f6f4315b77f5a52cc1080a84b9eb78dd574c06763a9dc81ceaa58060fbab774"
    sha256 cellar: :any_skip_relocation, monterey:       "ee5f818188e35c65f14d7394296ee62912da1e8a884969c280e477787842f6b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c7c15b306ffc6070ce3fabc0abb25cdf7aab3e295faa44a447dcbfce5a8a1cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "875214fee4acf98f88994af0d5c4be0ddb0b35667f119c80d8971a95c22499f3"
  end

  depends_on "go" => :build

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
    args = std_go_args(ldflags: ldflags) + %w[-tags=noebpf]

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
