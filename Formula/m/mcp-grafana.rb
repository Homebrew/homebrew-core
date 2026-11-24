class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "265b3541b97ec173c35bff992cab040aa4d1225279cb96dbb608dbc8182f6844"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    manifest_sha256 "7a32f72d6ad50c18bbdbcdeeeb13418de3eb92c320955b8456ae330b3247164c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b8987cf01f5ece9e9ac4ebdca1cb2079d7f9af1c480fd800c778f67b2dc1f620"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3b13526880ea2d1c3bcc8d4775a7e28baf2c9befad0a757fe8587187898ae059"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b5d1eb7e3bb32327c88f3f21a6680919c5f2bfdd375cb22952a4e36ed020ccd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e89ec7c48892b0646ad63aa74044949d9d4870dc7ac7689ba3cbbbf6b34b0fd7"
    sha256 cellar: :any,                 x86_64_linux:      "dc11b44b404f1906b7fc49ae82dfc53183862272a1010ab1f7ffd242af62437e"
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
    IO.popen([bin/"mcp-grafana", "--usage-stats=disabled"], "r+") do |pipe|
      Timeout.timeout(30) do
        pipe.puts JSON.generate(jsonrpc: "2.0", id: 1, method: "initialize", params: {
          protocolVersion: "2025-03-26", capabilities: {}, clientInfo: { name: "homebrew", version: "1.0" }
        })
        response = JSON.parse(pipe.readline)
        assert_equal 1, response.fetch("id")
        assert_match "This server provides access to your Grafana instance and the surrounding ecosystem",
                     response.fetch("result").fetch("instructions")

        pipe.puts JSON.generate(jsonrpc: "2.0", method: "notifications/initialized")
        pipe.puts JSON.generate(jsonrpc: "2.0", id: 2, method: "tools/list")
        response = JSON.parse(pipe.readline)
        assert_equal 2, response.fetch("id")
        tools = response.fetch("result").fetch("tools").map { |tool| tool.fetch("name") }
        assert_includes tools, "list_datasources"
        assert_includes tools, "query_prometheus"
      end
    end
  end
end
