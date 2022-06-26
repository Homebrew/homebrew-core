class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "a8bf90eed088fc40bdafbc741080a995f5ded73c2dc83d45a654fd40c65874bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0be2dd902955f68cd3d4e95d4b2c75ba30eaf9125d31facd0c7d141caf323121"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd7cad2ece9e5817f9e048197e20b32a09f97eb81a4ff01f71146b9daa45a3de"
    sha256 cellar: :any_skip_relocation, monterey:       "125d57a1995fbd85f7e264e6a15383850e1ee2fd67f4800399e0ab6cbd21cc9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "603f4f57bc555a82027723df8c81659afabe6604640f70cdebf25ea9a75a82af"
    sha256 cellar: :any_skip_relocation, catalina:       "c490955cd699cb583f31938ac7993ec1ab86ca513799ed19a115ad5e8ee40440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd0ecd7e2503b86ae3a27c254ddd5495a607e4b7e50548d20eebbe65e94cac9c"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  on_linux do
    depends_on "systemd" => :build
  end

  def install
    ldflags = %W[
      -X github.com/grafana/agent/pkg/build.Branch=HEAD
      -X github.com/grafana/agent/pkg/build.Version=v#{version}
      -X github.com/grafana/agent/pkg/build.BuildUser=#{tap.user}
      -X github.com/grafana/agent/pkg/build.BuildDate=#{time.rfc3339}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "./cmd/agent"
    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "-o", bin/"grafana-agentctl", "./cmd/agentctl"
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
        http_listen_port: #{port}
        grpc_listen_port: #{free_port}
    EOS

    system "#{bin}/grafana-agentctl", "config-check", "#{testpath}/grafana-agent.yaml"

    fork do
      exec bin/"grafana-agent", "-config.file=#{testpath}/grafana-agent.yaml",
        "-metrics.wal-directory=#{testpath}/wal"
    end
    sleep 10

    output = shell_output("curl -s 127.0.0.1:#{port}/metrics")
    assert_match "agent_build_info", output
  end
end
