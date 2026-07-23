class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.0.65.tar.gz"
  sha256 "edbf5fc6657f641f0a54dfc84d7979584dda3878cd7dab6b861885ae3b859c43"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c936bbb39bc286c8adcae6c991f5b23cfee32bebb8e3da7f1552c51b6aaf0e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c8305b36e977e702fdd8f7dd9693a56fbec1034855d49012ad0c7a097a5543e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75c51d8f1dc4973e9706901359f315be5cf50eee822271ef354361224a745586"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf23f3b41c8b251a70bbc9f53d60b02c4e2617699c0b13b83bdaa714899d0934"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eac5e4bc59703548e1458fd60224c3d862f14f082ce4bc7d4db5013575477387"
    sha256 cellar: :any,                 x86_64_linux:  "201413d367fedbe4796a91977267b155021385abc1181e945833bc862f1f6282"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
