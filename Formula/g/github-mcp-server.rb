class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v0.30.3.tar.gz"
  sha256 "50b4c044b951395506974559ca459c622cbfd4ed37e84bc2295882383863ef2a"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9db2447a97acbbf191e1be3af42ba2cdd2b9b7605a7cae2a21531d8540104b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9db2447a97acbbf191e1be3af42ba2cdd2b9b7605a7cae2a21531d8540104b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9db2447a97acbbf191e1be3af42ba2cdd2b9b7605a7cae2a21531d8540104b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "86b75d96b541a6163b100da25426644598f8bcb7e77531d85e66405bf6afdf2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d57f6337ca6e751c87dfb7a68e6f2848eaaec159f7294eac1527642cac859665"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58b7d86955bf52c2011e21e09123b383832999f798e6a001cd8227cba838470e"
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

    out = pipe_output("#{bin}/github-mcp-server stdio 2>&1", json, 1)
    assert_includes out, "GitHub MCP Server running on stdio"
  end
end
