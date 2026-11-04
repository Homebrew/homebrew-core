class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "0bc776f8b0d4948d48646477c81d7d29e079dc46e924e87339c66fe121b104c6"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1d1dd0c6a87a8443c879780e4782b6f2a493cb6787da381652d09d6dce98c572"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ffe746d9951014d49e54f34024d048b60c3c5b6e723de1c5807ad728f4b372c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "776b8c29a05a95d5f4b1de05daca87295ee00fe43f16a278a69591f196155205"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2bd318fb0b4b6c142886bee7604b1376483db687f3cef53b309d64cdd8969b1a"
    sha256 cellar: :any,                 x86_64_linux:      "87c94903f8a9780ad7bc7dd3cb5000a1c811e5cf96bdd3bb056748f204ea4100"
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
