class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "4c874fcedd82d5df4533ab79e1b675135dd77725500e006b1195a59c01a67d60"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec3948fc913589dbc7b92add59c04a7682594307f3cbc4de0cf4afe868374f8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec3948fc913589dbc7b92add59c04a7682594307f3cbc4de0cf4afe868374f8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec3948fc913589dbc7b92add59c04a7682594307f3cbc4de0cf4afe868374f8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8607407d33e24eccfb0e466bb778f2bd796aabe2ca10b1a5a6b7ded960177bca"
    sha256 cellar: :any_skip_relocation, ventura:       "8607407d33e24eccfb0e466bb778f2bd796aabe2ca10b1a5a6b7ded960177bca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee67d26912654d181ee7034bb6982c44cad3548e4b954621e9f041d770f4470d"
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
