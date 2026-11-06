class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.8.8.tar.gz"
  sha256 "713f398b52075e6389f09164e836dda4cb1068e7c2c4933ba488287fb084bcaa"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6ceffbebdf02d4f7d2c3621e1fb8347d8585e194fbf72382e17641272ea42f92"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ceffbebdf02d4f7d2c3621e1fb8347d8585e194fbf72382e17641272ea42f92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6ceffbebdf02d4f7d2c3621e1fb8347d8585e194fbf72382e17641272ea42f92"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ace99e2d0c45c9fadcf5df9731569c5a1b03a84cb34e83b1efd6f2945b3c348b"
    sha256 cellar: :any,                 x86_64_linux:      "100778d12ee4e5f4585d161d0027c781e5595c6a915d4bd19b6665a61deaadb5"
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
