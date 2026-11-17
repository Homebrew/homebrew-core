class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "550715e8a04a2b0db1c49a851d388c705ba30293955007bd92fbe8d058f4f4e4"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "56d119624e3eb37bffd5c5d2455bfa5f8f4c474aa83ce6af112ab9624c6e4bc2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "56d119624e3eb37bffd5c5d2455bfa5f8f4c474aa83ce6af112ab9624c6e4bc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "56d119624e3eb37bffd5c5d2455bfa5f8f4c474aa83ce6af112ab9624c6e4bc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "19cb3f131ef3c0f0234f8347645df781127f1abd127030e9e15d65c8e44bac08"
    sha256 cellar: :any,                 x86_64_linux:      "5e2cfc42e654fafda05b30f2c9d93d5b92894f6131f9149557d72644e688c325"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
