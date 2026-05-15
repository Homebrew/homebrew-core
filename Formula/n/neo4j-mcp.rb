class Neo4jMcp < Formula
  desc "Neo4j official Model Context Protocol server for AI tools"
  homepage "https://neo4j.com/docs/mcp/current/"
  url "https://github.com/neo4j/mcp/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "c31dfc4f2c63af446d1e27346d94b5fe93d758486b39510a032b74023568b365"
  license "GPL-3.0-or-later"
  head "https://github.com/neo4j/mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ca122f8f83a3298cc4044f12ff69bfd10cd5952b82c15940f89eedbba08b119"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ca122f8f83a3298cc4044f12ff69bfd10cd5952b82c15940f89eedbba08b119"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ca122f8f83a3298cc4044f12ff69bfd10cd5952b82c15940f89eedbba08b119"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc8e395dd54f5e17af2bd2658c121cf2c9ea3e9ed680dfcdd01d496e837d1aef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2223a7c55da23a2bc4e2e831ba2b034b6ebe5ff3d1bb35feedf92dfebfdb9fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "196f28f7c1151928f68551757e5bff0d217c434bece5546bc53baf9745911fca"
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
