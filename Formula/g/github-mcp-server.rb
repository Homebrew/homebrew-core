class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "c479ec7342e717b67a79dfa030f62fdb03282c4937ce0912d20d6c623269a731"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b482bc2e81b1476f1d571b41ca411cfd68aead444a9b1d392941568d46c1dce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b482bc2e81b1476f1d571b41ca411cfd68aead444a9b1d392941568d46c1dce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b482bc2e81b1476f1d571b41ca411cfd68aead444a9b1d392941568d46c1dce"
    sha256 cellar: :any_skip_relocation, sonoma:        "799f8b7ad829c7b5956a1c8028af238ca895d937a2b79a79fb9fc7212d24e92e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f169fae9d5103c451611ebd6ebebd1f563e7a1aebb787c89e3fb20e56d23840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e22a3017303894224e1c4a636816830bc1254d960125989b037f8477e651fbc3"
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
