class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "11831ba2d959790ccc080f588a208d72146a7c1cbb7fbdc8d7b408b2116dbbfd"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ea3128519570eaadf3dcbe89233877edec7a714d536c3d65bd31f26a7707a89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ea3128519570eaadf3dcbe89233877edec7a714d536c3d65bd31f26a7707a89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ea3128519570eaadf3dcbe89233877edec7a714d536c3d65bd31f26a7707a89"
    sha256 cellar: :any_skip_relocation, sonoma:        "4be7c7d6d88792d6eed2445e97a25d3a145970b7f28c745badff0e0d7020aa83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ae55f301f5cdaf84810096230040e0d3dbd97060cce58a855664e1c3216a7e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17fb9a62ffa7630cebcd9f94679ff1a4ffdff351ccbf37ef60c8bc7f2a69a334"
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
