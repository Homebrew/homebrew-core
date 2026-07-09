class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.0.63.tar.gz"
  sha256 "ce494199930c8dbdeaaa002042202b76a4ab96361947e8353c6d9fd05289dab5"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94dcfadbeb2855987e95204e4cd459d10e99aba57cf50b8afc16e50b9192ed72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "173a86d839c23512e32990c0db40be7ebd13905bd9b62d608a58a93f9a2585ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f62bfd18b66984ab88630c60a28406c9660404c01b35a18afc152f3aa9c61bc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "10a6619a4553f3eb962575d33050246d6013c77fc9fefe2c1eadebd39dd91f69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7246e1114f64edc5dfde10e885bfd370f3f48a15c68e141e3d424b127097d1a6"
    sha256 cellar: :any,                 x86_64_linux:  "9a134254897b60cfc2438aced5128ae99340b14b43be3da8a8e6bbdbd29ae2d1"
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
