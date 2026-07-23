class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "ab6f9018039e0562dc49b89e56a4a7b8f3486102d43bc8adffa6d6972445230c"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a68213538e7df7c8093b7cf420931dfd021621ca654980bbf989672803d09ddb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a68213538e7df7c8093b7cf420931dfd021621ca654980bbf989672803d09ddb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a68213538e7df7c8093b7cf420931dfd021621ca654980bbf989672803d09ddb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f18c67f95e037b1b87567defaddcd92bf4b83e988098bc570e8144511ae611fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1080367ae5bf7ce2ab75b16ed52b1323aeef994512469c44ae7464390b035bf4"
    sha256 cellar: :any,                 x86_64_linux:  "8241aa950c0d99712142554f2932ec938578d8906082bbd8e93404557493ed70"
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
