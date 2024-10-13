class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.43.3.tar.gz"
  sha256 "99d48af06ac8e2c8c6696508e53a06e1bab4e1dc3bbcd5146e9f0066fef1e9ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0df50c15aefcf0ef5966448c86bd08deb85084c685de2ad4b2f0dd8cc2f5a018"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27b23bd0769a183852d016149b1345504265653d08f1c68bbbe0fb6bff8a7997"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "508566ffd9692fdb49c66bff04865eb87d5953da70e5a4eaafa34088c1cf3e7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fd2bbd05f143fc7608acc767166f975176da4ce25c47dd8c03f387c761f9ec4"
    sha256 cellar: :any_skip_relocation, ventura:       "c44eae56d3105734dd889a4e952084b55af19e7c36a6d02068f5a369e165d984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a64752034facb371210f5da42f490635b21ee9690d19e405dece66f2622d87e4"
  end

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
