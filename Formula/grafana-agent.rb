class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "75ad5538dd79ab3fda6cd11a050770d2dd969809c212ff5d6671e6b5eba8e9d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c30658a520a87d6f4b1f03d1bcd36fa869cffccfa20438e0e28ac1e54557d367"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba568d6ba3195fd81110b00df03de3a2bf2266602ff0cc15adfbba55808a62ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9d05dc3ae01e2d59de308282b97dec77c27210b13e7719e99d4ab5d5273e91f"
    sha256 cellar: :any_skip_relocation, ventura:        "e5fc2696f3a5ec0402ade1e1276d2b8d38a3dd2372eeeb91595e9b8c9d3e6734"
    sha256 cellar: :any_skip_relocation, monterey:       "34f40a67b4cdd8e2de36d1b4c98315386840d2d6bc8e69656fe47160af008180"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c37987ae603442602fbf997465244a439519edcb6ab2cb571534ab497374796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68bc4b46b4aaff09f42eae2d3378199c2886ec42a1e85063b1909ff2d012a8c1"
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
