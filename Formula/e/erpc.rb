class Erpc < Formula
  desc "Fault-tolerant RPC proxy with re-org-aware permanent caching"
  homepage "https://docs.erpc.cloud/"
  url "https://github.com/erpc/erpc/archive/refs/tags/0.5.0.tar.gz"
  sha256 "54c1776002ed22a93741296781fc7996a1bf64bf3f243da23545958b2f182138"
  license "Apache-2.0"
  head "https://github.com/erpc/erpc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "52ccb24f609f9b60eff127042d78536861effaae4181fe546046d7423f73ab55"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dd3336e55bd122271381fd4b9a43e241aecb582a69c3d18e592be7a1f05f7726"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6e595520a17bc8ee26a9309459a3e5d2fc453505bbf328644917fbac9a283328"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "411e70a577ce12b114b456f83b05ca214d48f661577e7129bde8081bc48d810a"
    sha256 cellar: :any,                 x86_64_linux:      "8c7f6939cf296adca91f0d93b32ee1a48abe68095dfc3aedf6164253eb605599"
  end

  depends_on "go" => :build

  # `test do` block starts a local RPC proxy
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/erpc/erpc/common.ErpcVersion=#{version}
      -X github.com/erpc/erpc/common.ErpcCommitSha=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/erpc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/erpc --version")

    port = free_port
    metrics_port = free_port
    (testpath/"erpc.yaml").write <<~YAML
      logLevel: info
      server:
        httpHostV4: 127.0.0.1
        httpPortV4: #{port}
        listenV6: false
      metrics:
        enabled: true
        hostV4: 127.0.0.1
        port: #{metrics_port}
        listenV6: false
      projects:
        - id: main
          upstreams:
            - endpoint: http://127.0.0.1:#{free_port}
              evm:
                chainId: 1
    YAML

    output = shell_output("#{bin}/erpc validate --config #{testpath}/erpc.yaml")
    assert_empty JSON.parse(output)["errors"]

    pid = spawn bin/"erpc", testpath/"erpc.yaml", [:out, :err] => (testpath/"erpc.log").to_s
    begin
      sleep 5
      assert_match "starting IPv4 HTTP server on 127.0.0.1:#{port}", (testpath/"erpc.log").read
      # The only upstream is a closed local port, so the project has no healthy upstream yet.
      assert_equal({ "main" => [] }, JSON.parse(shell_output("curl -s http://127.0.0.1:#{port}/healthcheck")))
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
