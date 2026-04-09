class Neo4jMcp < Formula
  desc "Neo4j official Model Context Protocol server for AI tools"
  homepage "https://neo4j.com/docs/mcp/current/"
  url "https://github.com/neo4j/mcp/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "d4657f50de84dd960366081c14cc21fe493ea11d063009d72be11855a3a77267"
  license "GPL-3.0-or-later"
  head "https://github.com/neo4j/mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa44a48a418bb2ec756453224c3f125c7fa49fb34a772b69bf662d46a43a7712"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa44a48a418bb2ec756453224c3f125c7fa49fb34a772b69bf662d46a43a7712"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa44a48a418bb2ec756453224c3f125c7fa49fb34a772b69bf662d46a43a7712"
    sha256 cellar: :any_skip_relocation, sonoma:        "63fc3e56e1cda13e63e17738fa89a5e2b08bef62128c7ce35cd321d94e6180ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "420b41442ad4f45072df98303c8871f6b528a6815e1997487e1a1851624d7302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d893aee11dbdf01e72cea7074ce12dbe5ba13f42be933b93c9d6101efaad95b"
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
