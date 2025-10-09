class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "2341db83f0ecce8088d05df8383998c86ee6e058575a817a1b6d86f19cfb863a"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe463172a6952a81b52cf9f003e716e354c5bfb5c8e253bfbba5ca98ab5ea217"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe463172a6952a81b52cf9f003e716e354c5bfb5c8e253bfbba5ca98ab5ea217"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe463172a6952a81b52cf9f003e716e354c5bfb5c8e253bfbba5ca98ab5ea217"
    sha256 cellar: :any_skip_relocation, sonoma:        "1db95295ba1b0c2436d72e6dd4496f027688db0961586c578654e58b8477ce06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "664ff556ad407c3697572da2c6a0f9ea9c3b0d0deb862ce837af2b015b58d5b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c75e4ba8b1e23b501761d555e036f0d3c4bdeec77a010c644c7d9381d16225e5"
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
