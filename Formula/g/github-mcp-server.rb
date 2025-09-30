class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "69b19ec6b02ba0f405bc6db0bb08c222aa3a134b22f39307e0fe29d321e20d62"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de9f7e406e9cb283a45b6be085e4833be5e3801330b5ac8932e499fda700c2f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de9f7e406e9cb283a45b6be085e4833be5e3801330b5ac8932e499fda700c2f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de9f7e406e9cb283a45b6be085e4833be5e3801330b5ac8932e499fda700c2f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "44956d32d461f12c3a9ff9416133ec15a1636e3761f9a79c957013bc814bb1fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a6cfca324be0a417ca07a3e890b4ac412fc2047072cca13196d15e7ea3ab917"
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

    assert_match "GitHub MCP Server running on stdio", pipe_output("#{bin}/github-mcp-server stdio 2>&1", json, 0)
  end
end
