class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.0.66.tar.gz"
  sha256 "db97557535eb27d37eb35c56d5710cb0c286c45ddde2c4badddbcc1563ddd473"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2dece98fc5d3c69b9af13f6fbb8964ea30d7507efbd61c11c8dfbe8f4c64f40c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d4c9d07177c24aebc6255b590fbfd95fb25e476c919a2dec672066838c12bc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "526a39d2548a73991f7a5db91321d6cfab4def72eb2ca3e215c6f682c4eabc7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0af94528bf6073730933dfb5fc3ac332a6cebeecfa30c9e159d8756c3879c7d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bf50ccf982e620ca7714328fd929f04c5084814dd93161c0b9cd502f728b3de"
    sha256 cellar: :any,                 x86_64_linux:  "26ebd4269a1fcc21e9e519c0f390b6d65cf7c9b904bc4c625f1bfef55c853ba9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/containers/kubernetes-mcp-server/pkg/version.CommitHash=#{tap.user}
      -X github.com/containers/kubernetes-mcp-server/pkg/version.BuildTime=#{time.iso8601}
      -X github.com/containers/kubernetes-mcp-server/pkg/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/kubernetes-mcp-server"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubernetes-mcp-server --version")

    kubeconfig = testpath/"kubeconfig"
    kubeconfig.write <<~YAML
      apiVersion: v1
      kind: Config
      clusters:
      - cluster:
          server: https://localhost:6443
          insecure-skip-tls-verify: true
        name: test-cluster
      contexts:
      - context:
          cluster: test-cluster
          user: test-user
        name: test-context
      current-context: test-context
      users:
      - name: test-user
        user:
          token: test-token
    YAML

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = shell_output("(echo '#{json}'; sleep 1) | #{bin}/kubernetes-mcp-server --kubeconfig #{kubeconfig} 2>&1")
    assert_match "Get the current Kubernetes configuration content as a kubeconfig YAML", output
  end
end
