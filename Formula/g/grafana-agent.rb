class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.40.2.tar.gz"
  sha256 "9ed7f2c0de014277afaa10e1618ff2d75731c229ac83d95986fdd8065838b147"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e171dfe2312c92bdba0afdfccd5d2163fad93e9b211d514cdfbc21943704520"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07964f409e436abcf061784a2cc7258d38723adf0f17d871a80b35e9e96d5f3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4647d41dd93a8bb4d88c562f9b646280a69b77d6223cce719db459d59b91780d"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b0d749f75b8eca0842b9c42caa243e56fe0cd5f06d53a91118b2946ae4b819b"
    sha256 cellar: :any_skip_relocation, ventura:        "703deb9a77bf9e51c2fb656608a4db149db3fe70f2df7bdb9b3f386a016d9c29"
    sha256 cellar: :any_skip_relocation, monterey:       "33d6f0fa505917a01fc9347983d09ba220603b006731c1cd1d9021975d9ca919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d994506843cab71cf8c08b9d688575e83df6ccb5779cad12d5c716611d116096"
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
    args = std_go_args(ldflags:) + %w[-tags=builtinassets,noebpf]

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
