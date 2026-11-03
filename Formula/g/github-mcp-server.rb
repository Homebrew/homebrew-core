class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "fb85acd573def7a0a5d35739a52da51f1d42fe281e3a044b58776c33d8e0705e"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "600824ddf568560904ded2738e80ecfe05ed25d9a0098f85919ecd927079d818"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "600824ddf568560904ded2738e80ecfe05ed25d9a0098f85919ecd927079d818"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "600824ddf568560904ded2738e80ecfe05ed25d9a0098f85919ecd927079d818"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b8d7d1842303b0133829459102bae0b98c6d30b3a0d5fc477fbc4bb565ac62d4"
    sha256 cellar: :any,                 x86_64_linux:      "86ebb5fb1a13e9785fe20a64a1c1e2bc2c5b562d433629a964d19975e8d024d3"
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
