class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "b3068c638290820646d9c5c170c37492bf42f13c6cab6cebfc55135397daed1e"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bea7674b46b7bc5f2742708e16668d1f60f305a579282b2243d26a1deaaef2cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bea7674b46b7bc5f2742708e16668d1f60f305a579282b2243d26a1deaaef2cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bea7674b46b7bc5f2742708e16668d1f60f305a579282b2243d26a1deaaef2cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fae32f120cb113e2f34bf6058f3dd86ba0d5606c0638defeffa239ad25b929a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e46f02d54297cb1d908fc378dbe69977200825fa2469352cfa793a0f023606c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0f02503fd99966eb9fd9f1e7354c3ef1e2f1765ee3d775f325cc7954761b42c"
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
