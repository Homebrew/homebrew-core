class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "e9de5b2fb214a2a7f4da80d4a795d20b5918ca819c441c10b8e3aa109617f004"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1ab02af45e7054a0104ab6fdfdc682b685aa94c873d3c18e91d9dc561d068c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1ab02af45e7054a0104ab6fdfdc682b685aa94c873d3c18e91d9dc561d068c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1ab02af45e7054a0104ab6fdfdc682b685aa94c873d3c18e91d9dc561d068c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4951d39d8d9476e78206616b639216ab1a5a029357d0b96cb1a784ce0c3efaa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0306032369607e8ef425fd5461b2e1fae0b8c5151485eaab6844045bf18f81c0"
    sha256 cellar: :any,                 x86_64_linux:  "ec4115143e7155829f3f8cfea82db317c21b73238c8852234b59a14df7b6e3a1"
  end

  depends_on "go" => :build

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
