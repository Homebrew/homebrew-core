class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "a9c67f3a0d964e0b70d12f436d81d217857495386541d8a769614a2007301f0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0794498441723a7c6399ffb1a087656e1fc207200030a6dd20e7ed46047f6da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "639d9e2c018658dad257dbf0c907ef000937e154b2c53cd10f0c097524d45346"
    sha256 cellar: :any_skip_relocation, monterey:       "711be6d7569f6c7af910fdd1715ad9b68038cc69780a8d6a0b0f7b61a14d576a"
    sha256 cellar: :any_skip_relocation, big_sur:        "df6abc888bb344de87f2a7c6eec57476007df7b2719b5aee3948664b2186fd14"
    sha256 cellar: :any_skip_relocation, catalina:       "8c4817a8637e6feea17063890eb210bce38f7049c2c6e545bb3fe0b9a0940fb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87371dd011f148c37d32d2113277d74e82da8dc37f25b263015b279a034dd0d8"
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
      -X github.com/grafana/agent/pkg/build.BuildDate=#{time.rfc3339}
    ]
    args = std_go_args(ldflags: ldflags.join(" ")) + %w[-tags=noebpf]

    system "go", "build", *args, "./cmd/agent"
    system "go", "build", *args, "-o", bin/"grafana-agentctl", "./cmd/agentctl"
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

    system "#{bin}/grafana-agentctl", "config-check", "#{testpath}/grafana-agent.yaml"

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
