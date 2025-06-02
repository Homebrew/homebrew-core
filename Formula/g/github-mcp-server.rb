class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "824412c08b0fb8f462c6c59cc606791baffaaecb66810f4e274a3a7bd7fa6d99"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db1ff3f7ca90dea5b7b591686008f23a74291efb4bbb7be52b417b2608b404eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db1ff3f7ca90dea5b7b591686008f23a74291efb4bbb7be52b417b2608b404eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db1ff3f7ca90dea5b7b591686008f23a74291efb4bbb7be52b417b2608b404eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "23a1d199ea1d2cba9b494b3d8535ba7c0d884acf30b9601a8837512314d9283f"
    sha256 cellar: :any_skip_relocation, ventura:       "23a1d199ea1d2cba9b494b3d8535ba7c0d884acf30b9601a8837512314d9283f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acfaf80176388285cd66eb52e6a86b5760e3245b08e65e76f2899871f63d7573"
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
