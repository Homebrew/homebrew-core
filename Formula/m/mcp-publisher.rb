class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.7.7.tar.gz"
  sha256 "eac862ef640e7f43adc25701ca457eccbc066fda444c3f7e742dff6dcfa3e604"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55d46cc3d9d14b7e8d52a2dc0adea7845cd9c8e63485a21ddff376d67ba58b09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55d46cc3d9d14b7e8d52a2dc0adea7845cd9c8e63485a21ddff376d67ba58b09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55d46cc3d9d14b7e8d52a2dc0adea7845cd9c8e63485a21ddff376d67ba58b09"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4a83cdfda33894719c08cb1f50a5ff7585f43409bc139ebbbe8ea3403540bba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42d4a049d677d113849eda83b6bc1ae997e61a87aaa8eff902ffb0393c4a2510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc204f817f710bb08275ed014a79297039b5e052eadbc305877de5cf6746ac4d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.GitCommit=#{tap.user} -X main.BuildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/publisher"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-publisher --version 2>&1")
    assert_match "Created server.json", shell_output("#{bin}/mcp-publisher init")
    assert_match "com.example/mcp-publisher-test-", (testpath/"server.json").read
  end
end
