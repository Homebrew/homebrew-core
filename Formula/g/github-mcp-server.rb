class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "3d5c92c508a6e928a18405235b6dce5dacb3b4c23ff2ab6760666c560c9ab84d"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7de3ce022668e7ef2767f5b0e8dce1cbeb10915d17c537ef3afcc06f0061e5c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7de3ce022668e7ef2767f5b0e8dce1cbeb10915d17c537ef3afcc06f0061e5c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7de3ce022668e7ef2767f5b0e8dce1cbeb10915d17c537ef3afcc06f0061e5c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bd05e165ac648de3ee30c292ae17664609af8384c22ee5ac57d82677d2b6af9"
    sha256 cellar: :any,                 x86_64_linux:  "ca058772e9e014c6d7e3b365404a19e202126eb91f9b982992581ee0c1a3a3c0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/github-mcp-server"

    generate_completions_from_executable(bin/"github-mcp-server", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/github-mcp-server --version")

    ENV["GITHUB_PERSONAL_ACCESS_TOKEN"] = "test"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"#{version}"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
    JSON

    out = pipe_output("#{bin}/github-mcp-server stdio 2>&1", json)
    assert_includes out, "GitHub MCP Server running on stdio"
  end
end
