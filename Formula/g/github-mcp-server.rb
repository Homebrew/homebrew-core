class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "1cf05d7ffa73e43e7d35cbee0dbafcc3722d451926e4cb87c231acbd6a943c40"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83b0e0b4f5e92d2ef59ceaa2c66a683b2ddacb0098c1c78fce557f9f31ad150e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83b0e0b4f5e92d2ef59ceaa2c66a683b2ddacb0098c1c78fce557f9f31ad150e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83b0e0b4f5e92d2ef59ceaa2c66a683b2ddacb0098c1c78fce557f9f31ad150e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff78b9951490e6ce99771b8c20b33290891967680721d2c47f0094297199cb1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a09a43d19412ac208cc4c16bd39d2185f9bc5885d0371d085ea178a163346ff1"
    sha256 cellar: :any,                 x86_64_linux:  "31dbfa5c885b1da1d10333ba4557b06134461a0a3d84856cee9a492da11913aa"
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
