class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "93a9c8415146916153a6a1798fef3a062daccc5c90d42d814e37a0a8e594d538"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b9d19bf9bea364925006feacffe85806720f6949291f187e6c2f95aae1e8372"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b9d19bf9bea364925006feacffe85806720f6949291f187e6c2f95aae1e8372"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b9d19bf9bea364925006feacffe85806720f6949291f187e6c2f95aae1e8372"
    sha256 cellar: :any_skip_relocation, sonoma:        "30f474cf7a7a8e2a747b5ce079f75afd6bf45ea7b96c533b0c5f9ac98135c6bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccee9a7c81bdeff0b511990f4d883239766924d1460453682e992bc74320b59b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef1503f380456798f6c089df30973c6ea93c59b08f37ca31507fc6e9ae0f6fb1"
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
