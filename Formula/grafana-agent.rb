class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.30.2.tar.gz"
  sha256 "6b98f04dbfd2c106012d729200d7734302bfd923c3dbf284cf24c92951158dc4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2b6bd0519ed620131a1a539c4389a9e81741d96052e04808350ebb191e36890"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0ea474c48edc5a2513913519b8e6a51a9fa8265c1993e13e266fb978fc7e114"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ed8fe6d4e38a642fe6864df404606847c3b473071e5b1cab064de3093e398a6"
    sha256 cellar: :any_skip_relocation, ventura:        "0d128ca746775efef0ed7f88832a00165210115d945989623a3669b4bdfcd248"
    sha256 cellar: :any_skip_relocation, monterey:       "f5ab1b6301197c59c7293633773e37e509720614737d4789255aa930ca699f20"
    sha256 cellar: :any_skip_relocation, big_sur:        "80a4bb8362dab175f0b0eaa15d4e7984c34de80ea2ebbc2a583bb43f237d849c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a673c568d453975c1c4aa94a7e73666133d20179e082146c6b5ddd0a0feca71e"
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
