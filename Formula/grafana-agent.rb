class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.34.3.tar.gz"
  sha256 "f219de855d867f27c0efd43f7a24fbd1574962c788bf262a8ddfbddc091b199a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b066b707f0209a07ce2aa271fb17de29491266817c13989cdd51f7a8446107a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7654ec8a08981ff36eaad756e5e3f4aa9c9c86d90ca0e2ec7b9314dc2ff1e3af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd0355bdf115d73266fe6f4901b9475eff30c28aef4302a56812ff2169cdf892"
    sha256 cellar: :any_skip_relocation, ventura:        "66b71d92fb12379b21f16bd3d772b745693241b641713eba6f4876dc3bb1f3bc"
    sha256 cellar: :any_skip_relocation, monterey:       "874b1f0614cb012556240affe8f86ef39621f3ad612bcfbd50836993a06afcb3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c795e0fdbabbe49e210eecf63db36c14f16b49462ca70433211521d9363dfea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc6c7ad25279367b7e82840a7c8f732260e13f371c172598863c0b9c37f98f78"
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
