class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "621fd4eca813c715cc64149c4fd6d7ccb193ca9283a761ab129b8f869296217f"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5095440a17d12556bb8a03bf4a720daa9c12e76b663f7232c7bd6559f9221ca6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5095440a17d12556bb8a03bf4a720daa9c12e76b663f7232c7bd6559f9221ca6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5095440a17d12556bb8a03bf4a720daa9c12e76b663f7232c7bd6559f9221ca6"
    sha256 cellar: :any_skip_relocation, sonoma:        "48ed56c4b7967f17e1e3fffa88165bfb32788a2603c8ef23c56eafd522683eb6"
    sha256 cellar: :any_skip_relocation, ventura:       "48ed56c4b7967f17e1e3fffa88165bfb32788a2603c8ef23c56eafd522683eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "911fbb58aeb6c06114bc826a1d31e6658bcf86982e047ac0d43dbcb9da792c8d"
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
