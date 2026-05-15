class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "808157562a1e9431ec59099c87cbd823e8d33c668b02c48258af47b708782b13"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b04f0582c117b315ca1817b289d7a284ac8e482e738b0a891b3592db4ce14b56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b04f0582c117b315ca1817b289d7a284ac8e482e738b0a891b3592db4ce14b56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b04f0582c117b315ca1817b289d7a284ac8e482e738b0a891b3592db4ce14b56"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0e0b5f895a0becc48c96246ef9ea9bca0746924cc900be877edac2aa1685f2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "956047cf1a9bab5199d2af4bb56f7c0d02f7e5e9a184453b1b54dfc307831496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e319b1ecc5942808e3061e715b0ed3d523d1c532de26da8f14042e9a120b7b8a"
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
