class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "3e93ef063a5c11dc9fa3cf4a68f56547e79b436f85de7f9ca59729fc4c4199bf"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c03dd73b792f78362f60e722f96a74e25e9d5f7a3a5790480d885190542efcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c03dd73b792f78362f60e722f96a74e25e9d5f7a3a5790480d885190542efcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c03dd73b792f78362f60e722f96a74e25e9d5f7a3a5790480d885190542efcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e85ac6609e106a64d5aeb6acbcc4508bb43bb95a6c6235be86081c280e9b5614"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee270510b8b7a40311fdb2816e0622553ffc7f6184bf7bc3fc582a6f18139ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed8810cfa50aa899f165679ae0982582e1a56543a3847eea420c0e97fadf8ed4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/github-mcp-server"

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
