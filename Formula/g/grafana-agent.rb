class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/latest/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.44.2.tar.gz"
  sha256 "ef8b19e0bda6214ad1856d636226c50e9c9690da45791c5da090227f81fba65a"
  license "Apache-2.0"

  # Keep livecheck until 2025-11-01
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8947e913b3811be4c82cadf51e83bd39cc6c87b6bf13a6d0acfe132141794f2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d6dcd2ec5dac8ec8dec064b8632768520d1f03d8e90ff4662128c97d180b091"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c491c1d0d721cb5e2d7e23cd394ae67d6397e73ecbcf1fd17d1a235858efbe81"
    sha256 cellar: :any_skip_relocation, sonoma:        "d807a3a6b6e3c8404e30180ca15b1dc0ae746d2dbb869e6b19862b611d0ecc14"
    sha256 cellar: :any_skip_relocation, ventura:       "c9cc0258e949864468d103b764f1f9a7abb64db194efa5151d07ccf8d7d51f9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96a26aad76428d765023b479df15a501ca44fe3220788ec5337ed0263ad27713"
  end

  # Needs EOL Go 1.22 to build (https://github.com/grafana/agent/issues/6972)
  # and deprecated upstream though will get security fixes until 2025-10-31.
  # Disable date set 3 months after planned EOL date of 2025-11-01.
  disable! date: "2026-02-01", because: :deprecated_upstream, replacement_formula: "grafana-alloy"

  # use "go" again when https://github.com/grafana/agent/issues/6972 is resolved and released
  depends_on "go@1.22" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  on_linux do
    depends_on "systemd" => :build
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/grafana/agent/internal/build.Branch=HEAD
      -X github.com/grafana/agent/internal/build.Version=v#{version}
      -X github.com/grafana/agent/internal/build.BuildUser=#{tap.user}
      -X github.com/grafana/agent/internal/build.BuildDate=#{time.iso8601}
    ]
    args = std_go_args(ldflags:) + %w[-tags=builtinassets,noebpf]

    # Build the UI, which is baked into the final binary when the builtinassets
    # tag is set.
    cd "internal/web/ui" do
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

    (testpath/"grafana-agent.yaml").write <<~YAML
      server:
        log_level: info
    YAML

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
