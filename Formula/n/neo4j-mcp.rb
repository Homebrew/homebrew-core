class Neo4jMcp < Formula
  desc "Neo4j official Model Context Protocol server for AI tools"
  homepage "https://neo4j.com/docs/mcp/current/"
  url "https://github.com/neo4j/mcp/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "806a91fe1f819fa49f1f65cfb55dc67b8431dceca3540a6436506c7206106ce7"
  license "GPL-3.0-or-later"
  head "https://github.com/neo4j/mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc713997271d686d34daa9a3481175b1b98c60c7e36ad522d856f267c3fc371e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc713997271d686d34daa9a3481175b1b98c60c7e36ad522d856f267c3fc371e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc713997271d686d34daa9a3481175b1b98c60c7e36ad522d856f267c3fc371e"
    sha256 cellar: :any_skip_relocation, sonoma:        "55926cb798e2460f05b4232ab3b5c9f69ab4cc655fd60446817e3ec8effee7ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa2bc22d9aff35665dcebd9f07b46a640cd66156bbd5b608d339b919c9ba524f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a25a5be0c014ffd11f645198bfdf284ecf259cf947040cdddc9f453d27cd6a50"
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
