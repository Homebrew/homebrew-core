class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "9eb26623b3d44bdb4f8f1d7651a2ec83e3a0ddc4f6466fb845f6f54221ad42fe"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ceae80cf32fa53b108a37d6a528f9b92b51229eea4ef0136a4a8a565ccf7374"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8d87b20a7c265f9ef07c7605d3cef1cca80050fe1369832d38d729115de6705"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef32cd03209ce19819d2f072f4277782ec4eb596bbb259923b38e6ffbb09c1a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8c02b6c52aff037368b4fc901c7d416c2d949cb2ebcb37bb9a0facaeb1b3089"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7564fdddc33fbb30ef51f82132b9f800838798cd29b4a90af93c4febe0ea4b3c"
    sha256 cellar: :any,                 x86_64_linux:  "531508ea879729fe577e137a2e4f62fa5e82a4ddb34c03afe6f4f20b581860da"
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
