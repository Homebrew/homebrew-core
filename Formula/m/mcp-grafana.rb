class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.11.6.tar.gz"
  sha256 "5c3b9812d4201b5c27acd2feba310fbb23701d3d0c79db8aa0b4f802c9dad43e"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e0e1c63464312ec1f9fcff47359b306ef96a9a6f4bf9da6b25cfea1f1aadc32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fad24900212a593f25275fa9c9d1a09f3389203bac0aba1af1bfcf31e1e8637b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04af6b9ea1a5c2caea7becab1510152bc57e1f6903210a1c7c59994091738191"
    sha256 cellar: :any_skip_relocation, sonoma:        "28c8028c018f72c856bfca47ff37911932c4535106e0bc66a717b7008d7bb543"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c66fd56810309f3241bbff94fe9ebda14a82864710b49706fc99e076159d8d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab5dfdc9b3ed8761aab83b83e299de0931f8fdcc6c029377759095980e88c3de"
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
