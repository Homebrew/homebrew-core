class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "05e90be0d6a01bca9ce8425e361f19082d2c6122bb96f010a6ba95542300686e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dbbb18d4d49803f3511f8366c65778c721871f395cf0f8bbf58e9bb941a0aee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "830fe1e85ee85363844674c77f9a0374d3a7cfed310dbd3987efa038e936e66e"
    sha256 cellar: :any_skip_relocation, monterey:       "3566c6c0b9e5f81560638aa38f853c179bf44a3b8f4f243bdfd55c20d13886bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6f9f4c08ec49d60682d625247bdb2b0361800e62ee440ca84d2d1417cd1fdd2"
    sha256 cellar: :any_skip_relocation, catalina:       "9c5d869dfd54ebb713c3aedaa7d27c3e59d314e180a99a3be1148586b43d6030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "497dabc803b5a73df45433498c88f45ec52fec283e88c659f10ef1abb9c990a1"
  end

  # Required latest https://pkg.go.dev/go4.org/unsafe/assume-no-moving-gc
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

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
