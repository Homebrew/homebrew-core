class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "83d33a7ce0744f7075ba35804091059feb434ed4fc4a8ad31e2d6c20c43226d9"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85611401c97f60bc54e8bc693e176d7406d56f64395cc1f04b85f74f11e9560b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85611401c97f60bc54e8bc693e176d7406d56f64395cc1f04b85f74f11e9560b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85611401c97f60bc54e8bc693e176d7406d56f64395cc1f04b85f74f11e9560b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5ee5b7bd3b53cc9f13c97f4047d62335c8c123df3045ffd3785205e0a9e601c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22418b8a88b54aed2a5187f1aca4e5860ee4c82f76f410f92329abc1ab24867f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48904356a0721615c0d76f049ba395abbd41405a5a281371c8a5ccaee4bdad87"
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
