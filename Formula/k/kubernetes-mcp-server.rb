class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.0.67.tar.gz"
  sha256 "650449c50fb661857db047764991e7f890ee411a1cc47a3c40f3cc02694817c4"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "92119222827a647523f5b927064a17c52b7e1f6be82500709590731a19639838"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "202f44a2158228a5e102b079fc75192c049778a48f46f3432ce32e1b1042e136"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0790712329ce1a61a7091d6163776a3c5e9d7f3c3d598d1c301a9a3b16d26075"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f776ecc45fad087723530b8db79c27ce0bc43dee73e1b9b139503f506f0dd415"
    sha256 cellar: :any,                 x86_64_linux:      "fa5c8361ae863dd68a17138de6df9da09bfb66d61da94a866b6ef9a7896c88d1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
