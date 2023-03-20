class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "2b91c3a3e522d79a9375bba806684cb6a9a14eab02613c81a01b8440d5bc7a12"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3b6e8737e003ce6f30acfa89f078a82716c1245d4a0d8808c46e59e4dedd32f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "149dfcff8c4c8afddd6f0ab08eab616dc30adef4ad79641237463d50124559a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2784b12d84ad2a523b46438ca7ddd1840ecb0c4a2b5c9882eef9b45074f0a21f"
    sha256 cellar: :any_skip_relocation, ventura:        "5cece3807b77d08e275148520ba24d48dd8b411e37baa96ab3f3cd13524bf657"
    sha256 cellar: :any_skip_relocation, monterey:       "93b3f9c629ef53a24e08ec0232b809e11bc085ce1888988a6c67eb659a53d403"
    sha256 cellar: :any_skip_relocation, big_sur:        "9be7107bdc4d0efc0642f9a1b957f6719f195c04371d8594441b90669d6bba9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db5eacc80070a232d6cae96ec16d4bd3dbb516cc08523dfc70ffdba1a2c5a021"
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
