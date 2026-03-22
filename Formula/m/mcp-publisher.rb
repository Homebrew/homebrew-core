class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "cc7f90da70ecf5bcba06eafda0c5358c5fefa06f1caa79a2e9ee91b9073dfd50"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f6d99766ecf12631eb011991bed61a0165de5b651585c8af856abac1af6894c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f6d99766ecf12631eb011991bed61a0165de5b651585c8af856abac1af6894c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f6d99766ecf12631eb011991bed61a0165de5b651585c8af856abac1af6894c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab330bd4eff38b17aa8dbd34e4c9afd21c3da8b153d958f7270ee573594554bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65972049b5b82e4fce0cff7e48c6d9c81469405a498a38fb8b7666b73e6234df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "310969522eabe473aaedea39874b0a56d85f907fa4f947cdf933b59f0bf12fa8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.GitCommit=#{tap.user} -X main.BuildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/publisher"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-publisher --version 2>&1")
    assert_match "Created server.json", shell_output("#{bin}/mcp-publisher init")
    assert_match "io.github.YOUR_USERNAME/YOUR_REPO", (testpath/"server.json").read
  end
end
