class Neo4jMcp < Formula
  desc "Neo4j official Model Context Protocol server for AI tools"
  homepage "https://neo4j.com/docs/mcp/current/"
  url "https://github.com/neo4j/mcp/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "360561dde43d8df9bcab844ea3363c9650b2031ead03fbe681f7b31303adb2b2"
  license "GPL-3.0-or-later"
  head "https://github.com/neo4j/mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc3f7d3e8bc7887418d9d811b0efbbd63bd5fec681723917da713f44064095b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc3f7d3e8bc7887418d9d811b0efbbd63bd5fec681723917da713f44064095b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc3f7d3e8bc7887418d9d811b0efbbd63bd5fec681723917da713f44064095b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2efb75c4f802aecf49d0720b7be54cab297f9c44d39727d80ca08ac49b59e4d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88c5f7f5b79bb81469c1adcaea023f82f85c1b4855b9264096ba1801f614115b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd93e1c59df65c9a8c7f0d038894b894606cb15ddb4b235a521125a97fa9c2e4"
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
