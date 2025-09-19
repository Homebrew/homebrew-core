class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "3058497fe92f3804a65674cf8fc529ac9839cdab1efc07703cf78639bcdbcefc"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c98f707dce3844003dfbffb56e6804e76cc873de68e53cc31372188a30ea2174"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c98f707dce3844003dfbffb56e6804e76cc873de68e53cc31372188a30ea2174"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c98f707dce3844003dfbffb56e6804e76cc873de68e53cc31372188a30ea2174"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7f26cca9e34a275b0bfa36aaa02e7fa2341fe860f8d46bac51c099aa6f4b717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d9bc758ea6ad958ba5517787b0908645fe068f872751a06cf2e963df2bda7b1"
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
