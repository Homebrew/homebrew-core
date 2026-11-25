class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "a2b31bd783c497f41913705945b5f0e253748e5ff27b464731eae19d1c657489"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "52ca86992248021e7b6896f855b0730bd22c8a6ba33c21a97705effce27bc10c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fc08e9b66b2a91ff10e6e7fd64ece90f27fbed66acadea7e26e1e0eb4ae7a21f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fc08e9b66b2a91ff10e6e7fd64ece90f27fbed66acadea7e26e1e0eb4ae7a21f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fc08e9b66b2a91ff10e6e7fd64ece90f27fbed66acadea7e26e1e0eb4ae7a21f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2e61d08551c976258840b971017408c2539f1b4c89538dcfc746bf93c405dd61"
    sha256 cellar: :any,                 x86_64_linux:      "28b410faffa7f23120e33822faf748b9ca0fddd9764ce06714d501bad0008a66"
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
