class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "52da01ea69c872b46ffb1ba0ebcb2ab2a64779c3986e586a4c9e7783d77d0a19"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "690516d5da79ca56ef4898683e4f5e90d6cfeadccc46206db44345a731ea58a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b341056ff7ec09586e5210f67f1923becdb9b02e6881b7303e91a022bb15a91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d17953e4bf84d0658c7eba88b5bd7993142a0a0e5f5133c5a08382f67baa500"
    sha256 cellar: :any_skip_relocation, sonoma:        "5faf1286d990705738124b1de76361cd5c17737ffb5a32e8ce88b8a97e520221"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "602a177a653c71df3f5b4f8d4eec15e2be2966ae37075865adf18d4978af7f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfd9e7ded81abcb938d078164f2a5abdc8d268d62353a3b8bfa46c215171fc8a"
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
