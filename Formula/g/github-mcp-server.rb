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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6ca29eceb8a726bf519bc0570a1808bd54206b319936ec4cd2e7e9e67d04373c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ca29eceb8a726bf519bc0570a1808bd54206b319936ec4cd2e7e9e67d04373c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6ca29eceb8a726bf519bc0570a1808bd54206b319936ec4cd2e7e9e67d04373c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b0947e116f1c40edc1a484c9450480503714f9a6586fd61793dc6567b3e9fa61"
    sha256 cellar: :any,                 x86_64_linux:      "623e37e897649fdc9da41d615ce8d07d2e693cd750a28e8f1b5e7dfb51018204"
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
