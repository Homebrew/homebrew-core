class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v0.1.1-release-validation.tar.gz"
  version "0.1.1-release-validation"
  sha256 "b79f546fd467ab98f327f95f25003b6fe43570314c3baa1bbe303f22188e8f9b"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83d9176f4360bef31a9e67aa2fd13531b5b0953cce315f6c96d33ef9efd91407"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83d9176f4360bef31a9e67aa2fd13531b5b0953cce315f6c96d33ef9efd91407"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83d9176f4360bef31a9e67aa2fd13531b5b0953cce315f6c96d33ef9efd91407"
    sha256 cellar: :any_skip_relocation, sonoma:        "a58fe7653160e3382a00a0c3815498f1d9ee88a07d853e50e127185c7f9f70cd"
    sha256 cellar: :any_skip_relocation, ventura:       "a58fe7653160e3382a00a0c3815498f1d9ee88a07d853e50e127185c7f9f70cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1337d8546f1de494489ecb5d498c304b01e838b51c4896bf2eb0bc4d4c6ddc8"
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
