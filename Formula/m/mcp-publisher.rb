class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "d39577bd7f9c0e99b14b0b1c7b3c603f113016c81b074713b45c7f322b8a99e6"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ac9f4c6092132164fe7761ee767e1db5c9a6f209102b5c8b66dd1a18da8404f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ac9f4c6092132164fe7761ee767e1db5c9a6f209102b5c8b66dd1a18da8404f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ac9f4c6092132164fe7761ee767e1db5c9a6f209102b5c8b66dd1a18da8404f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef83506e85a0a1e9dcaf88109c180d83f3c3a1dc3bea43c7d540f5b4288771cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b9a8299efc576f13d5ab300763ba30647fc13f230eccf8c29882299b99be341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "523253487af79a95ed34005144b366a0cc910a178ef3cbb3c4ab227bbc0c6683"
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
