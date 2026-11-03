class Neo4jMcp < Formula
  desc "Neo4j official Model Context Protocol server for AI tools"
  homepage "https://neo4j.com/docs/mcp/current/"
  url "https://github.com/neo4j/mcp/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "046289f55e09265b1afcc6d412cba5da580674bf919ce0f1ee957c1c3275fcd3"
  license "GPL-3.0-or-later"
  head "https://github.com/neo4j/mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e17ab0c5250cd4ba8a879c186b8c1bb9b6662136468aad3948d31158993b6f24"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e17ab0c5250cd4ba8a879c186b8c1bb9b6662136468aad3948d31158993b6f24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e17ab0c5250cd4ba8a879c186b8c1bb9b6662136468aad3948d31158993b6f24"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e9bfc2e4385b52f5f481745af9302dd2c64337732c6405ffe088cec1eb254850"
    sha256 cellar: :any,                 x86_64_linux:      "e336abdfe391eec59096457a47421eca434cad1e02309d4e9b1ce9c7adf59a3c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=v#{version}"), "./cmd/neo4j-mcp"
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
