class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.31.3.tar.gz"
  sha256 "b55218728cbbbc86ca8242d073bfe6297d04314edaeaab7e6b63b69d80ee61a2"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1076070a9f7bd1aa67cb69611afc8a92827f537cc4a297eb788ba006d77a419a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bdae1b6dad03d192695f062f0459105177a39c31e989106f98d7643cb542692"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a18b438333d670161a5dae8c5db1002b721d8b7ade4953108ff7b389f93e412"
    sha256 cellar: :any_skip_relocation, ventura:        "247f280ad464fca3e3ee9e9309de0487fd32b2597ee2273870ed3385723e1499"
    sha256 cellar: :any_skip_relocation, monterey:       "d820b7abf8e81dd5bfce84a655041dcb7c40ae2c6af7c33c9246cf296f2adf17"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca7824d58a3c21f3be101022bacdd8c53fe99f9866b70a1d5a557b8d657af451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f53640e6fe119178a1cc3215be1bfbada2f5ea223f0819d545da5a0770416010"
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
