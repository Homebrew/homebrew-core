class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "245cc4bb90ed3af887a7abe45118fcc83af810022f61069d737274638b2b262e"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8005aa211113204a2e88303d37a189a1effe918b1302a5eda36098c1d3e3a2d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c0c1bf9f1b784b530d8002813a2a9101621f90e6a0a8ed9510a373963ed9aba9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c795eb6ade698311e74b0d3f16019d6b981e8ab4aec5fa6b4047483ec78d7017"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a131d3c7c9eeba2a25986dc152394b5fb11ef1fd2c619bcc0cf196b456e40d89"
    sha256 cellar: :any,                 x86_64_linux:      "539bc48e09d5feaff834ad207c4dda8bad0e63d67ca1d2a9b16dfb8b26f5a810"
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
