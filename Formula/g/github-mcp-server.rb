class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "fbe867ad8608e2ef41064b8c9bf6f059a28b57f82cec815c3074def3a1dd3bd8"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca7acfeab72628df93190ba6568c2274e0b367cecba8609086ca9ea43ff8d828"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca7acfeab72628df93190ba6568c2274e0b367cecba8609086ca9ea43ff8d828"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca7acfeab72628df93190ba6568c2274e0b367cecba8609086ca9ea43ff8d828"
    sha256 cellar: :any_skip_relocation, sonoma:        "710c282933dff39bfd449abcb3e74fa8f0e528a75bdca18824b077502d5dbdae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6df3729fb7ff23c9cf89f0b33554f4b6960d358876831c01970e99399a5fece8"
    sha256 cellar: :any,                 x86_64_linux:  "c10d834184307f6a36b9083a5358a278cd5ddb75f90253c9df69f23e281d19b5"
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
