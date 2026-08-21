class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "a418ebd3c8900d5e23a8d5795265f785f82e4a74f6f1770f505e4bc4c2fb28a5"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3d878b35d9c81cde07c55b59dbdd21e7c904ca6b602bd203fddad5d7e95d10d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3d878b35d9c81cde07c55b59dbdd21e7c904ca6b602bd203fddad5d7e95d10d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3d878b35d9c81cde07c55b59dbdd21e7c904ca6b602bd203fddad5d7e95d10d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b29cabb5023444830783de9e521003a480034dfb9ab30a5e065b7d26cd7676a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "901f9c05371df17710ed0b5f5864de5977019d3482adcb56f8346bace22a6a4e"
    sha256 cellar: :any,                 x86_64_linux:  "4503e238905d0d7db39c6e6e0219e52031e4d5db42720a13fe53a1d4a67b00e8"
  end

  depends_on "go" => :build

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
