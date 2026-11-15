class Neo4jMcp < Formula
  desc "Neo4j official Model Context Protocol server for AI tools"
  homepage "https://neo4j.com/docs/mcp/current/"
  url "https://github.com/neo4j/mcp/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "8597bc20aad4ff3aa94fa66d1a0cfbda44517289570b237d68ce2d2fc35c6237"
  license "GPL-3.0-or-later"
  head "https://github.com/neo4j/mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bebe6168a65fb8eb79896d0f63e5e2e1bbf743a8410b0a4472e558b85a80f7bd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bebe6168a65fb8eb79896d0f63e5e2e1bbf743a8410b0a4472e558b85a80f7bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bebe6168a65fb8eb79896d0f63e5e2e1bbf743a8410b0a4472e558b85a80f7bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ee6997751e018bbb218cea75a4e34b716bbce38aeb67ce893cb81f8fc6706e52"
    sha256 cellar: :any,                 x86_64_linux:      "9d0329b91767fa57ef18058b8d35d801a91e127c14691ec9aaab29d52787b597"
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
