class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.0.59.tar.gz"
  sha256 "fa529da8707c4e6fa24d813eaf895dc2616c2a5871b39a8a8c0973fbf93e1c40"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68100bcb3c9da2ff0337efb165f7b161ea61de31976c2280cdbf3ebbed110a97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea846cd4a813bf971164366b78474ebc8f2b9429c102f681774ca07a1228fc24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c349f5746adbcf812fdee66c7b39c8c7602c20dc545ffcd91111583083d1cfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "53a5a185ead5f3a0eabe0f729fa9b53606075d77e84ff87937ace25225420e93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd45fa71187c872de1afd17055c035e496e4840c462e110806544c064ca46d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f0a500b212df7f47ae43b24f714cf6ad212db411d9305e17ae293ab9ecf5c22"
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
