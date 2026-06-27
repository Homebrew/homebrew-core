class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "f1377df93a76b580a9b35a5abecc95587ac15fdba2ee6a4dd795eb12bde95173"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e321db19940d98a44d12729501d8a86f457ef03b270185a2c3d87f4820fab76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e7a2096a30b0f357b8388156b4aeb55455b37dc57600e27286aa08d03fd583a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a941bffcb9feb860502595b88a222864660ac31ecaaf8e3b6d1cc172ca378408"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7527e2f0809cf53d028739d43651d3c1162f794430e6bceff990cf8a4c39f22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b38f4a7f7b8006646f9082acc7a54d86b87c0f2dd156fce32aed1e9654886d2a"
    sha256 cellar: :any,                 x86_64_linux:  "4b6dc35bd4e7bea49d16fbeb9bda24c67093a4de1895dfd14fb2d2299e25f962"
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
