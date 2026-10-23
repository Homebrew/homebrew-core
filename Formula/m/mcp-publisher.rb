class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "a5c0b6259398dea678a91335d5cca3b89a93ef84f9102063d5caae83a6826859"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "245b61ea4da5fa80d88681ba4890e0215a9be47ab9d709b84dcfa17a265ee9f2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "245b61ea4da5fa80d88681ba4890e0215a9be47ab9d709b84dcfa17a265ee9f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "245b61ea4da5fa80d88681ba4890e0215a9be47ab9d709b84dcfa17a265ee9f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "11c6ce2f111307d7af8152d964336d4e7c4ff6caaaacadd7aba4c2b4ee09c1ce"
    sha256 cellar: :any,                 x86_64_linux:      "f024de06f3564189b8caafb148afd1a4dcdc5664e1f3ac58dfe6dc6228a21dc2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=#{version} -X main.GitCommit=#{tap.user} -X main.BuildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/publisher"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-publisher --version 2>&1")
    assert_match "Created server.json", shell_output("#{bin}/mcp-publisher init")
    assert_match "com.example/mcp-publisher-test-", (testpath/"server.json").read
  end
end
