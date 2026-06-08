class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.0.62.tar.gz"
  sha256 "1a9b763867180283b1352af9d83aee21b3950f9b8dcfa49d4f27263398c1c893"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce49ca692dd824d68a8f1da69cdef1ba965ad83f6677a771b552b39cba13a20d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aab43be1dac786d80ea17f14f59adeea7ab7d16cf6a304cd72d3c267d898c28e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8c92b66a05d9dc94e0be366be29d93e438555fa60d74badfc5715aad15684db"
    sha256 cellar: :any_skip_relocation, sonoma:        "7140d639f1e7823292ac9b22b3e8f86df1a56197859e6b5abc68e343084f486e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7750ba20d22f278000392ebff7c5a2b630f0782e1c9d9973ab72d8cbc843dd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0da225bcca8a92a3d4c847b571f14869553f282682b8ed6c34ccfa8ebdd30295"
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
