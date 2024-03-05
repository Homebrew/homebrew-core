class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.40.2.tar.gz"
  sha256 "9ed7f2c0de014277afaa10e1618ff2d75731c229ac83d95986fdd8065838b147"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b03d16e253827e0fc595e415cdd1b44169f4ff29579c9706e816126784179fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39861dab2c6d2f68cb379d042eaf0a4c9a3238286e695bac800516c33cd55a5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "501664cf5d80ca21587d6e103365acfc3883c8b8527c54bee22f2892cdf9568e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f516a9d6ca07576b9f46c3ddaf7954bbbe914f91eccb404accf5070c16dcf8c"
    sha256 cellar: :any_skip_relocation, ventura:        "bd518a9ce4ab7c80cdde77143f958d4d04b9d3751a056717265f34935efd1824"
    sha256 cellar: :any_skip_relocation, monterey:       "24d61cd169f51d1ed2301ec995f76fdc49aa35ac992df011baac1233611dd8fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65b4f1ba05d2d554a146ddbb6c36b097fa8eb7d0c27e9e216891d187468dc143"
  end

  depends_on "go@1.21" => :build # use "go" again when https://github.com/grafana/agent/pull/6139 is released
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
