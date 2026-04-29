class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "31303bf6a854cd51f0e9570b6c6d6ffc89089d243f18528f869cb3798dd0136f"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4076a9f354f5d788e5da7ca5422882a68ac04907f3421ef2930a77461f36e7a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4076a9f354f5d788e5da7ca5422882a68ac04907f3421ef2930a77461f36e7a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4076a9f354f5d788e5da7ca5422882a68ac04907f3421ef2930a77461f36e7a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fad700f2b476eb142349f15e1cb2b48d627dfad289cf296c8a97f604c21e63e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82d481e3b9a18c9a6b0dd00e70241eb3715cac8bee47002dd55b96ecb0382e5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bcf587b0dbe405e5057b2dafbe23892c50b82fdc46e95f4ab2be2d596b431d2"
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
