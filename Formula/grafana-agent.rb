class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.30.2.tar.gz"
  sha256 "6b98f04dbfd2c106012d729200d7734302bfd923c3dbf284cf24c92951158dc4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e939578782b1f131d02745817d0ce292a98e85852364135a532ecd50afea22a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebf49db6472bc2e5325f764d82b79ed92cf426da8b80d7803e34f0058864dd02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd5691486d9ad604af38b54ecccf14ae204c5ce0b903bf6d81b9bfd2bfd21f22"
    sha256 cellar: :any_skip_relocation, ventura:        "a6de2e77ccb56495c96e06083a2ac0bb15f4d7543cd0a810292e70fbef63aa56"
    sha256 cellar: :any_skip_relocation, monterey:       "5a41ed36b795304ae278978bf293646c01830cf4a3ec2d47a250f1f562b7c956"
    sha256 cellar: :any_skip_relocation, big_sur:        "55ca13561a26e89d09de9b607ee857e87302a4e281f480f862aca201c09d9f04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aee0e18946028edfec3bb00312226f17236126659d62bfcc943075a27ec0f1c5"
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
