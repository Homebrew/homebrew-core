class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "0bc776f8b0d4948d48646477c81d7d29e079dc46e924e87339c66fe121b104c6"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0315260a1ef3b33a1c8b4640eb5180d565ad18ef7c2be06bfd275717c76d6360"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a2e2212494537f0b25cda85b78cc8e48138242004d3a98cad44047e4191bfe33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "da24a32a56ee04f9cb0108bb91cd65cae04a00db23ee22236f5bd21f465ef721"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9ae0ed74c8c425892ad224f242cb043fab4ad372429d1c3dde84a453ebd852ee"
    sha256 cellar: :any,                 x86_64_linux:      "ba1767e75b41c1b3ead3815ff8c61e343fe7a74b95a2f9e78b37c2e7babd1132"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/containers/kubernetes-mcp-server/pkg/version.CommitHash=#{tap.user}
      -X github.com/containers/kubernetes-mcp-server/pkg/version.BuildTime=#{time.iso8601}
      -X github.com/containers/kubernetes-mcp-server/pkg/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/kubernetes-mcp-server"
  end

  test do
    require "yaml"

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

    (testpath/"config.toml").write <<~TOML
      kubeconfig = "#{kubeconfig}"
    TOML

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"1.0"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized"}
      {"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"configuration_view","arguments":{}}}
    JSON

    output = shell_output("(echo '#{json}'; sleep 1) | #{bin}/kubernetes-mcp-server --config #{testpath}/config.toml")
    response = output.lines.map { |line| JSON.parse(line) }.find { |message| message["id"] == 2 }
    config = YAML.safe_load(response.fetch("result").fetch("content").first.fetch("text"))
    assert_equal "test-context", config["current-context"]
  end
end
