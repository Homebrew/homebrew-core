class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.37.2.tar.gz"
  sha256 "8a7fc7d32781c04f3af2eb61b7285130058059481919c11374b8ed9fb49b9371"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aac42d80099217fa98316bcd110e2c30a1192ac0255a3dd3fd1fd0bf3c1947e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e756954f2d5faaab75d45c477290bf77a25cb4ee7b588b16b685791c87fdb886"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48304c2a3db15035c5c3720735e6fe26a9bb77feb9ac7112c11f1b7828d31739"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f2f6396cdcf704a906845dbf7ad972b0b945add0eb6328d8c4cdf85dc613ef7"
    sha256 cellar: :any_skip_relocation, ventura:        "81e44e8a4ec3a181107d94efb642a8a3a4d535f293b180ba7af54bbf7752b873"
    sha256 cellar: :any_skip_relocation, monterey:       "deb0d56d4dd16ddabc55441df5d9a5324e98a3d0daf5debabbb5aeca2df10b61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54b95913977da46c815ee8d9deb06dd2886512f1cef2484245bc7febebd7af07"
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
