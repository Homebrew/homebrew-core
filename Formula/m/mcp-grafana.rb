class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "57cace46d2cca79de1a34e6d43393bfba7afc92f7a93ecf5672d747f8ba3cc66"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4979b69308a1bd3f9e8c136f2c4e2f981ec6b34b49195d27c8f371efe6e5e4c8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "573998eaef1349bcbdc496a30fbbb0ce699b43445722aad6a1661c6a7dccf590"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6504dc6dfd6a38b7ed849e29fb2d158328b70e279ef2c2f875635f34a7e3fa8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ddf8d064fcf835d54facee3d25b7756ccddec941faecff64d92576687d1f4766"
    sha256 cellar: :any,                 x86_64_linux:      "c8d447329387693cbc05c91b931d50f347cdf99ac94bb3f82de123726547c5ce"
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
