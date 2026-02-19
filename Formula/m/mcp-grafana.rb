class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "9dd4b52fbb27615e1dc519fed3e37dfc778a51929f672aa86886755c43dbd74a"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa0252fadafe81f6e17b996991d159c9562254beecaa95f4a9ce8da4d4848c30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ee881d9a4e2688c39e145b4c969acc1e3afac74e09465640a95abbfe1040ec9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "276f31111d5557e41eb175614c99575516fa97021c5f0d5df9b3e8216c8e0f6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "868568f8646361551dfe831e123023483a1fca85aa6ee8d11ad87e3806276237"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab27bbb226e8bc792824bc941630bc431135cc08e1d4af19409460b2fcb278a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd6616987fc49250a662cc5b7cd803ae6204842f01f6c425968b4283f3bdf8d3"
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
