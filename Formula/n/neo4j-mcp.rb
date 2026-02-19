class Neo4jMcp < Formula
  desc "Neo4j official Model Context Protocol server for AI tools"
  homepage "https://neo4j.com/docs/mcp/current/"
  url "https://github.com/neo4j/mcp/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "a2fb7ee8ebafad99c70914df0c30ff4cb0cc2df8a96bcb205c26efc14e1a321c"
  license "GPL-3.0-or-later"
  head "https://github.com/neo4j/mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44e98333f247f3548a19125cb8f33d20159bd54fd0a2fd3215477f85511d3a32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44e98333f247f3548a19125cb8f33d20159bd54fd0a2fd3215477f85511d3a32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44e98333f247f3548a19125cb8f33d20159bd54fd0a2fd3215477f85511d3a32"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab1f323726357476342e44f1b99214616af8af65ab6885453069b7a03f4ac331"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e3a785cf36789e4b001351c58229ac70d632d51b9c5de7934a184d27021dca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9d2141f2432779e28c1481b169fb8c1ef673f1c367a1ae78e0a7b340f435e3d"
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
