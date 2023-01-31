class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "277e03290382a41ca139ec001f07beb1ffa04729df5b55bc09c42e696e6f6b70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbf086f1e39bc501d9f7c2dc51d2fa20e0b1e35d02f2e698821787d042fabb62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "573b0270125d6e42a956c5f0266cd9a392ce8aa6917b95317dcb5f782b9e864f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acff1c648b3c8eb11a71b18327c17a11fb140c2cf077d282c355f6487a8c68b4"
    sha256 cellar: :any_skip_relocation, ventura:        "72e99cf6195d6d868094a4aa5b2cfbd77c6623684288cca0c48c6f9bfdcd9819"
    sha256 cellar: :any_skip_relocation, monterey:       "348b394bac5c22d7b4c29b3665b54a49cee707b8d8d3ea1178dc5a9f0cb516c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f045b21e7b72f50f1fbfd4a2516bbc91af8f50dddac583ade3ed0b6095c8830c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "539c82c833a329045e7fdd9e3bbc523ddaf26fca11c64a20198a48a014f2cf5d"
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
