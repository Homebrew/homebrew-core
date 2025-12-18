class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "b76be0e6f7b81d64a11d8acd0f3797ce0fbfeaf002d1ced467ba97c9d7e5e0f7"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4e6d2d0649ce21cac0443fecd69f891b01e7aaafc8ab11fba74e5d84e0620b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4e6d2d0649ce21cac0443fecd69f891b01e7aaafc8ab11fba74e5d84e0620b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4e6d2d0649ce21cac0443fecd69f891b01e7aaafc8ab11fba74e5d84e0620b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "32e58b1cb76f737d9e14c5c5ba8548accd339315ed6d6df4f06ce90bc92f3a0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbec96d28f17e36c2eee435418a152ba24475645a63bfdb5d99e4d6119d3f046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d8c5ba7578224e0b26dcb3d0dfe3992e9a1fbc7a442bcd058b682625b02a009"
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
