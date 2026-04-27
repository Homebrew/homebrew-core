class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.0.61.tar.gz"
  sha256 "466e8b510905695deb94aff536e63635e197962f5a49a9fd68637a65b72b4d3f"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "addc15b3779ea1e10957039884989edf77a9682bfc801549816fb796739753ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe7bc2525eac72411bb607f81e73267b2c4dea223cb98169b8452a419b3807ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c2fd0e6ab2e70c4fc0bd4e11a46a97a63f1e51eb33488ddd460b726611c57ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe83e0e66eeff2ba62a58ced1ec06d6b4db97df9c02af882ef2667cb6c2ed7ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87a54d8a78faaa651f250f5d28883fa007c12bb9adeda10edc9c7d0e58e07067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c306a38c3f592869f85f2336a4fcea605950438dcd316d7b3b1702fe3cc75ce"
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
