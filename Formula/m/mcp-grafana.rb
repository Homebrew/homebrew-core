class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "90857dbd58efe2da1453ebbd56f85d3dab45dd9fc2942a0ea231cd81ad7fa659"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "116958c4dd932206db573ce1f53fc8856660c0fbe8608753d1d319d6b9836ae5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7c012d8dff1a546e10630c835f922109f4f7146887aa39426297791096693590"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1ebe6e7aa36b3c527d5a14ae0ca011ac438f107e81e589d5ed0708f5ba47d6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1f150038fceeb46e453e765f9d1b683a02b94ad5932369cbe6d79afe7800c3f1"
    sha256 cellar: :any,                 x86_64_linux:      "4d8a4e2c816e0cd7cf56de89ad1097da3a0a3ecff81ec25bce801d7384b2aef2"
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
