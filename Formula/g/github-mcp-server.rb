class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "220072144122d6983c2095ac7125a3b316b7ef2416f7a8657ef6ac99a8604d24"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82fcf21eb716a32dbb3dd12abec5acb7fb18b0a4b6cd9960b353efc5968cc340"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82fcf21eb716a32dbb3dd12abec5acb7fb18b0a4b6cd9960b353efc5968cc340"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82fcf21eb716a32dbb3dd12abec5acb7fb18b0a4b6cd9960b353efc5968cc340"
    sha256 cellar: :any_skip_relocation, sonoma:        "c05594f73b2f6e60bb939936263d2daa642911ec5cf4d42f75b76f403debe521"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50463d1b68af2fe7c1c2257c3754029903b063f29a2973d8c537edb87b5941a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93a2fbc539cd3435c5a46cda1cc4f70f8e0d3a7728befc5388fe616d225ee799"
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
