class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "629431eba25126c0ec041a72fbf64c13bba0b862518f4458a37ce23367c7dee7"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5572730e75ed561f1cf368e1440a3e0781214ad997bb3f3ff249c325c37f801"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8384a3b116496171ba0e88ccd1b08ed09bd98787094dcee96d75049454cbab3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b319b27464035c040b7cb3ee5261f08a08cd3a20298aaefe6628346ee731dc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6066d2ffae2846b6e860b6dca17c19e1945aa2a3e36a0d7bf141dd88face55a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e0dd48d968947bbc6843ae338c61bd297fee3c90a205bb13ec57e2a4aba1b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f83d416340e369d1862cb75ca4501652d1e93f73649339d9fe05481b0a1339f3"
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
