class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.0.54.tar.gz"
  sha256 "c2dfb0323f83d275598399342dc2404df00589f2118535448ce40a330278c25e"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ac2fb3937644ed73cd6456b52adfb9e6c74571d2db58122baa7144ba2a7e49b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77178c6e9185b4f900c7d9a1d2922861c97ff3b6d592695f946fe6f39064b818"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f12e52bb36d5386ce4db2755c8025ffb8482a0b7a911c7261cd039cf8c0198e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "61aa78569c82cedd00eb76c918e4e2bb3fd6cdfddb99c6506fe70d27d591a257"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17025806c352d93d3dc70857b5bec6a13b09f298447b177f3e683ff6f4a5367c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99d06fcabae4d8fd6f42124385dce587408a7657818f3ab95d778e3bdb4217ee"
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

    ENV["KUBECONFIG"] = kubeconfig.to_s

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"kubernetes-mcp-server", json, 0)
    assert_match "Get the current Kubernetes configuration content as a kubeconfig YAML", output
  end
end
