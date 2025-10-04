class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.0.52.tar.gz"
  sha256 "4f0fe6d7c8923aa300e7410649065792f77fc245e1517e6042091d3e2abbbbf1"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "357345441ca3f6a235eb22877c0ba7dd9b18228d4ff48952c4d5ebab603f62ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "764ce7c4ac4e2853cdd2898efd2bd162f67d5299ea16e9cb4b525d3177687f28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d77c669a2506b8dc7e2fd27107435b76f0dcdb909ee6998d096525c8df0c4e5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0af45313354f2c1ba241d523d976758481de8e117d0c829fce8826b60afdeba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd23d6dff91a62a0e4b99ce76b5bf1d0fc8a5b5b1995be6b5609f973da83fe31"
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
