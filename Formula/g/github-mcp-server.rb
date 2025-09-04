class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "3b3fe5aef82774163e0052f7f83eb29bf32ec20c987bd5748f57651a4ca05a77"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aeba47ffbc2ab8f64c059260a366d5b32cf846d9094b4d77df38cbf9bff8a52a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aeba47ffbc2ab8f64c059260a366d5b32cf846d9094b4d77df38cbf9bff8a52a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aeba47ffbc2ab8f64c059260a366d5b32cf846d9094b4d77df38cbf9bff8a52a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d08f3d952a2c191f454469200841fa5f547b979faaa51f398debc5d21cf09f26"
    sha256 cellar: :any_skip_relocation, ventura:       "d08f3d952a2c191f454469200841fa5f547b979faaa51f398debc5d21cf09f26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3910410918628dbe0d705d60efb1034034b27047c9b23be8cc31545e0b1dbb1a"
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
