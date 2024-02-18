class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.39.2.tar.gz"
  sha256 "54105d08cd2db3e0116677dcf651593136a92093bfe7453a7ee7a678a64adab9"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aaee0a6831b0f6fa8361234342d5debdbb944db67d6b354f2887a03eee295abe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e71693fa3ff5735da5ab62aa6718710fc0b197771a6504ae30da7d92ec1873c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51267fd43a29f8a45148ea82ff1e0a35718dc196e7bdfcc0a098ea43494febb4"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ce280ff6549a991260ebd2e1302c20dbd207072af87db2f84ca9d1f1693305a"
    sha256 cellar: :any_skip_relocation, ventura:        "0589e1095288feebd70677ce346372332590e54a4fc6cfaf3954a9e46c4d55ea"
    sha256 cellar: :any_skip_relocation, monterey:       "fa0b7b7c948fab33e0b8bea06ee935a2dedd509ed8531a2ee324ec19f7a5e0ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc2e97302d803e547697e7449e015267968781a05e391eaadaf679ffa772d23f"
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
