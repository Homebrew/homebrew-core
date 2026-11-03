class Neo4jMcp < Formula
  desc "Neo4j official Model Context Protocol server for AI tools"
  homepage "https://neo4j.com/docs/mcp/current/"
  url "https://github.com/neo4j/mcp/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "046289f55e09265b1afcc6d412cba5da580674bf919ce0f1ee957c1c3275fcd3"
  license "GPL-3.0-or-later"
  head "https://github.com/neo4j/mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "300341cffeb1c642c6da57a52ef7cb9a8e0e6390dbb7e96291d39cf3a6687f7c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "300341cffeb1c642c6da57a52ef7cb9a8e0e6390dbb7e96291d39cf3a6687f7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "300341cffeb1c642c6da57a52ef7cb9a8e0e6390dbb7e96291d39cf3a6687f7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f0ef123ffcfa0fad42111ba681d41fe49295dd135416fcd835d20be0acabb322"
    sha256 cellar: :any,                 x86_64_linux:      "106bf401531d9d0f0e27ebd271b2b18bb78343ecac73d3b20728a2c26f5b21dc"
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
