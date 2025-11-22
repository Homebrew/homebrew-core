class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.3.10.tar.gz"
  sha256 "083661b2b66653d7f420578780488850639027e50019594ebfef9c1613a86449"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc4623fc81067ab720ed7daed559de8c39b2ca08e5e35c30ae7a6cd3c7490219"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc4623fc81067ab720ed7daed559de8c39b2ca08e5e35c30ae7a6cd3c7490219"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc4623fc81067ab720ed7daed559de8c39b2ca08e5e35c30ae7a6cd3c7490219"
    sha256 cellar: :any_skip_relocation, sonoma:        "82267afce95014ea2d30f0491ec00dbb11fa153bf9103a66aa0655a0dd860a5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8d689770be630bbcc052ae0755e1907c95f6455f251cd588ac767df7d03c5db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8e0eaf0d11e756c7d4d39ec76e9e9ff53bec780d2787f288c52e8b0757c72e4"
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
