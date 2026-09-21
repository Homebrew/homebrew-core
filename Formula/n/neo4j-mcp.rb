class Neo4jMcp < Formula
  desc "Neo4j official Model Context Protocol server for AI tools"
  homepage "https://neo4j.com/docs/mcp/current/"
  url "https://github.com/neo4j/mcp/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "2aec25a09e477a79d7a220e756b21f04bddc3ccc9950732bc1d727fd4f760f91"
  license "GPL-3.0-or-later"
  head "https://github.com/neo4j/mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5b9189be516d533646d660f773df219ad37a1c02ae3714864cea9e7bea5e63ce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5b9189be516d533646d660f773df219ad37a1c02ae3714864cea9e7bea5e63ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5b9189be516d533646d660f773df219ad37a1c02ae3714864cea9e7bea5e63ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "5b9189be516d533646d660f773df219ad37a1c02ae3714864cea9e7bea5e63ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "da0bd9fe40c0e690a9ca21dabe0ac1c7abf962f664f3836f8fb14178b4c79fce"
    sha256 cellar: :any,                 x86_64_linux:      "e1eff114fcc20868ea57cc9dc71513aa1a098c7ef109b37ff4a550f4df8fff01"
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
