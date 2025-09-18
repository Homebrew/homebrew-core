class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.0.51.tar.gz"
  sha256 "8bcccaf29842f45f48c7940b3179d74210a0f621f8f7f134bb71d057ac52ec11"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51c762628a4d5ba2c929a06b14ed29d571206167e0432347b441006dce85641c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80eef89e903de6194cd694a91cfcbc3d80b1a032612128b2410cb53fcf55ba6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fcf114d25ff570365fb47ea4817c02756b458560ed6a8698cb6d2f0c8b935a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca2eed25f64dbb62ca3b87eea22e8b8b70288d08013cef64b81e01382a44466e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7154507377a277175bac64a0d8404ebf1a1f1d8a13096a8f0712bc24997e5dde"
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
