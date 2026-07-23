class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "52e7a8c225b15ae379fd99f5345b3d6f6a99daba0b49d5c52445e22723f981ad"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9770623b00b0fd4b9f6828d0c358f8cfa7b46c5ae3f59223fb6ca3a72c9d0c5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "680317432103e69ff86ec5f3d9dca09368a7640a2e39a1328da1761c1ea19845"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c9f646965230ad9f76419ed7ed622c8b7d46efd9f2dd496b47633373e2583a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8aae6e84b4441b8cc1ebd418d67034ed08db280c43cfc057a7e5a5a21e3917ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9145980fa9391714432675286a76da87fc6b171a7184c1bc74978a6292e976bf"
    sha256 cellar: :any,                 x86_64_linux:  "a3ba5c3e6ae608c33db2f684aff2ec5bd64d1984c4cf388e16728ddef8758898"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/mcp-grafana"
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
