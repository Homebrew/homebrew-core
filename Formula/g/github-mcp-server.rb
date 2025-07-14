class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "ad6580d2ad66f5ec11fa0fc339d571034930ec0390b94fcbe2252478d20ad07d"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfb8db2d5000955a2498efbc749b6242e79edb70e0f1848e570e8555b9ee7b0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfb8db2d5000955a2498efbc749b6242e79edb70e0f1848e570e8555b9ee7b0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfb8db2d5000955a2498efbc749b6242e79edb70e0f1848e570e8555b9ee7b0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0704b2fbc2a98f50a67c5a98166596599530d6144169dbfc61fefe1a886728c6"
    sha256 cellar: :any_skip_relocation, ventura:       "0704b2fbc2a98f50a67c5a98166596599530d6144169dbfc61fefe1a886728c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85c01f81e507435d2b707f59fa09fe31a3ea9e18ebd15d344b8e73e87714a78f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/github-mcp-server"

    generate_completions_from_executable(bin/"github-mcp-server", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/github-mcp-server --version")

    ENV["GITHUB_PERSONAL_ACCESS_TOKEN"] = "test"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 3,
        "params": {
          "name": "get_me"
        },
        "method": "tools/call"
      }
    JSON

    assert_match "GitHub MCP Server running on stdio", pipe_output(bin/"github-mcp-server stdio 2>&1", json, 0)
  end
end
