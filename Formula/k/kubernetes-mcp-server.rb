class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.0.57.tar.gz"
  sha256 "e08698ba6279efe51ea0d17d830c7706efacfecf5581db62951e8159669bc0f5"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30b1fd2000be0ad853be033cca51101ec0ce09a89c146a2229febbac88938296"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42edc37fcf5979f3bea35cee4d568d25c10244cfd36cca4f5da3436afc8d7c8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "259bf4cf85f54f672471348cf98e730a5883854947875c78c2eca7837d6d7a46"
    sha256 cellar: :any_skip_relocation, sonoma:        "229b50e48a9b025b620600eac047162648baf851af3ce760e52eb58961b4cd41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a06fffa6ade10219eb6ee51813ee9dfb0e7fb1d5641a73add36e0dd351dda7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33afccd8a11eb3669ee3cfb241dc466b0424c0ec42e7a795ecde942196a4b680"
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
