class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "8b6757f278089a2cfef4527658699c3888fda2099dadcbef40e2240a54178f8f"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8c9acc185c7685510e6d7b9f10083af6b5287b9b9ac07d6df5a7940fbae600e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8c9acc185c7685510e6d7b9f10083af6b5287b9b9ac07d6df5a7940fbae600e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8c9acc185c7685510e6d7b9f10083af6b5287b9b9ac07d6df5a7940fbae600e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcc14e381ef0a4f8f76d2d051b6b21822782f4851e81d17ffd72a5e263276941"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ebc0b7054999c22f51fbd996f53c2eb58f5e0925e5dfe6479fcb3afb2cdfe94"
    sha256 cellar: :any,                 x86_64_linux:  "aea37f961e78b2847c5ca5596523b7ee916fc4149f9ac64d2fb1df59b6230ded"
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
