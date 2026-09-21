class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "b76d212a88b72048f45d79c2ac4010de46918a4200714f9b9d42ff536bd6308d"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e0cac811ce080a911769d09440ca60435e817c6fee4ea9269ee0dc3f9e1f4b33"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e0cac811ce080a911769d09440ca60435e817c6fee4ea9269ee0dc3f9e1f4b33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e0cac811ce080a911769d09440ca60435e817c6fee4ea9269ee0dc3f9e1f4b33"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "383b63e6e9455e480e81461aba47fd37a2eb473c95f1513475c0c4c1063dfe86"
    sha256 cellar: :any,                 x86_64_linux:      "6daf30ad4ccba21acc5649212125175bdbd8349a49982a81a951d31245b4edd1"
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
