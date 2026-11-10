class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.8.9.tar.gz"
  sha256 "f428da284e8907d4973546a133fcf5d2a03143bb41ba4bfefb1144fbf205895a"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2519bc375de9ecb05c5beb703ac5878ed0e9ef23700920e3a81ed05a81e52c07"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2519bc375de9ecb05c5beb703ac5878ed0e9ef23700920e3a81ed05a81e52c07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2519bc375de9ecb05c5beb703ac5878ed0e9ef23700920e3a81ed05a81e52c07"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4a1df9ec085927c11e499d2732ce33df74374b4d83ecfac5fad9b7ff21c1cf95"
    sha256 cellar: :any,                 x86_64_linux:      "79988ec88f6e85b998ad4262dd25a21cdd8213b22910b1a24b1f895b1ec75d64"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=#{version} -X main.GitCommit=#{tap.user} -X main.BuildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/publisher"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-publisher --version 2>&1")
    assert_match "Created server.json", shell_output("#{bin}/mcp-publisher init")
    assert_match "com.example/mcp-publisher-test-", (testpath/"server.json").read
  end
end
