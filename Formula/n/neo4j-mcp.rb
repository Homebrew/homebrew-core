class Neo4jMcp < Formula
  desc "Neo4j official Model Context Protocol server for AI tools"
  homepage "https://neo4j.com/docs/mcp/current/"
  url "https://github.com/neo4j/mcp/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "d18cdbd894a03fa97b66927d7fac0ec4feed927b882ad31654690809fadc6a84"
  license "GPL-3.0-or-later"
  head "https://github.com/neo4j/mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22c7bb38f07c8913a9dc28276bbcfc61a1e3084109458ab1d1b6823d04b28e17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22c7bb38f07c8913a9dc28276bbcfc61a1e3084109458ab1d1b6823d04b28e17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22c7bb38f07c8913a9dc28276bbcfc61a1e3084109458ab1d1b6823d04b28e17"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cf5659f82d45bb553a228b35a1e5b67a636150d122ff5daf920243eb5b9711d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15c9253bc34a0ce891071ddc908dddc5c8f9af76e47a451f902c926e0e5aea72"
    sha256 cellar: :any,                 x86_64_linux:  "cf60cd45d22eb566178875b2a1020d550e733b7fd5af3126131c233200038bc1"
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
