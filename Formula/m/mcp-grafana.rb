class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "b0419c29b4937b1cf8f50d396ac5d6ed2170186cc7c2cccc08fd923bc99eb400"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dbc8c66b1680d89317fd77bd3b590788523f7ff4358848da34aa72d9993df458"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2aef6fe13ecb3c24fda23fad8545d7c63f4078bd2f0f463c02b61b9d9aef23a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3e05b8a1325d9bbf1567774551bc51f7cac21f37a4040a93e0a8ec61012cb08a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b7980c1f7302eec2233f8ecd31ca5a171f08ec4ab52e9859712893cfb603c7d6"
    sha256 cellar: :any,                 x86_64_linux:      "12a0738baa571e06a7a256656aef82ffad1af92882e31a6ee5fad04c165a3a7e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/mcp-grafana"
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"mcp-grafana", json, 0)
    assert_match "This server provides access to your Grafana instance and the surrounding ecosystem", output
  end
end
