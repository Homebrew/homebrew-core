class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.0.56.tar.gz"
  sha256 "ace3a1dce3bb5cc4421714706791f3de215c68fae19d3609d5fa8785ab4c389d"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a5312a967d6b422b3234cb991ac92034df3b295dcdaa70c8927c9f0a5421c3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb84eac404400a62a4b4f158e9978b60ba5644445effcb79c06d8acd014c01f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15c66c777dee15fd119bd4128f8de5e564ea26d01b647469ebb0ed8eaa13d8ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "28f61bbb39337d0d0e933f76e464204c4440ee9e1fb3d15410d0aec99491bbe9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "702833360b725847be9b23b68d6eb3a343e4ed6a55b2cead64b75a99da1356de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2af50affc9b82ee94551d20103e8a131ed43c741d72831157a72edced5e04f1c"
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
