class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "dadf6ecc393e4c53ba802e663993095289b302aa95a7e84f6f61c2eaf4449381"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b31003506caa34c43c636838bc0d79753d4258a0abf63e5b970a1c3a6db12bcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d4c48658a53b76ae43dd420e870bc769abf2aa9e13ab00c0ef80f7794decd8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "990c2f1af4c81bffef0eb8bd0ec6eafb3467137c824bb061f667029cc4bac68e"
    sha256 cellar: :any_skip_relocation, sonoma:        "71075c56c9809d1e5eb43347911e65f1965d3862e6a04b562f2f77923f7d8031"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "076e83c2c4547d0a32d3851ee9b0011dba6d56ee256082b574fb91d65b73170d"
    sha256 cellar: :any,                 x86_64_linux:  "70c7e2b7830eb6d91b9266968ab1522b6b24d3513495cdefe1b82070abbba40a"
  end

  depends_on "go" => :build

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
