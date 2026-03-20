class Neo4jMcp < Formula
  desc "Neo4j official Model Context Protocol server for AI tools"
  homepage "https://neo4j.com/docs/mcp/current/"
  url "https://github.com/neo4j/mcp/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "97e0d0788c2c8d6ced72f56d6b6bbf8fa12f9375b6f9cd88b7acc429bb5f27cf"
  license "GPL-3.0-or-later"
  head "https://github.com/neo4j/mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92d841cbeaa0454ac7c7b222cc8542a80c5e2b420bcd5e255fc8229d19cd2bfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92d841cbeaa0454ac7c7b222cc8542a80c5e2b420bcd5e255fc8229d19cd2bfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92d841cbeaa0454ac7c7b222cc8542a80c5e2b420bcd5e255fc8229d19cd2bfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b202e6d534ff483effc5a9ee122e6ab8a93680378896f3676fb5eb43d82f32aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c7ebf7644b5ca32e99985731da9168df7966923384bb7a0cb4450669f3dfe58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49a3d4011abeef8b3a37590cc1819f720a4f302d2445e566e5e6653c360d531c"
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
