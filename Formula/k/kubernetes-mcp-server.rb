class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.0.60.tar.gz"
  sha256 "2c5a2491d9cdbfc93824ef3f206d3f0cff20ccde933d7cb922fdb2d818c7afa0"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "267eb11485c9fb86cd2d0cc75ea90e499cf7172d386a8cc6208d62fb341d03a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0c51307bfb627267e3c9dc3f4da7ee74f11e7bcf758b62c3f8a2a0d5d4acf1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "288eb7e496e2e04c5843c214754774210e6f561e1672ada2cfe572966b098b73"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f0a7350a6a8a05024b88bfec9b9aac37f04c52e12936fa0c71e030bb75b573c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2bedad1110034082dda925ad956085775ad4cc508ecf6f0492410fc441c0ebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "323bb8bae86ab25965f772e8799f7c63f6f2d0c8d4d744a4a70510f6145c2887"
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
