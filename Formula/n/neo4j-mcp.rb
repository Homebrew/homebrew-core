class Neo4jMcp < Formula
  desc "Neo4j official Model Context Protocol server for AI tools"
  homepage "https://neo4j.com/docs/mcp/current/"
  url "https://github.com/neo4j/mcp/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "bbb679c6b1e7c7e7c2350875720be9fe666469c4842a0b65e2e531cc83fe1792"
  license "GPL-3.0-or-later"
  head "https://github.com/neo4j/mcp.git", branch: "main"

  bottle do
    manifest_sha256 "bb4098206e646c920c804d5691153d46f2df6ba88da73f84460937a345942fc6"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c6ae706755e180d4f5ded823f6be62ba7923585e1fcdd7daf45db637226a924e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c6ae706755e180d4f5ded823f6be62ba7923585e1fcdd7daf45db637226a924e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c6ae706755e180d4f5ded823f6be62ba7923585e1fcdd7daf45db637226a924e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cda7cc3660eea7d07aff2bbb5e4ee731336f2d30f0e7bfb297eccbac071a4811"
    sha256 cellar: :any,                 x86_64_linux:      "f1dbef014caa54e36fd1d6ed24b6a6613006b2798cf4da5a99a1ec990979c16e"
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
