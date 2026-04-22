class Neo4jMcp < Formula
  desc "Neo4j official Model Context Protocol server for AI tools"
  homepage "https://neo4j.com/docs/mcp/current/"
  url "https://github.com/neo4j/mcp/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "fa0505c084927210236a6b9f732b01f5143ba09c602d9285fcdcde9cc15edb61"
  license "GPL-3.0-or-later"
  head "https://github.com/neo4j/mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "324f4daa4a3e0fc6fd28860a9adc12302a94daae672151bf0ca2cca4e9f6859d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "324f4daa4a3e0fc6fd28860a9adc12302a94daae672151bf0ca2cca4e9f6859d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "324f4daa4a3e0fc6fd28860a9adc12302a94daae672151bf0ca2cca4e9f6859d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef8bb5e086f111f4ed41016ce1c8d6b638439aeef1ce95cdd7aac8ffdf69a33b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1834a3bac323916c3c028a266d5689a7a6c73b78fdf7f73b7c2c788ed2b811f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f1b7ef522c24faa45f0193e8c8ab15760427fc014c0d2dcd30006ebd24d9e61"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/neo4j-mcp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/neo4j-mcp --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/neo4j-mcp 2>&1", json, 1)
    assert_match "Neo4j URI is required", output
  end
end
