class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "580ee6f3ecbe9a56948cad29ba08e0b6a66d57659b6af83e65a3081381fe4a7c"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db3ade578d2d4f91bad1a18276e60f1d8e1e66fa44bfea6192ec95bc46f41a01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db3ade578d2d4f91bad1a18276e60f1d8e1e66fa44bfea6192ec95bc46f41a01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db3ade578d2d4f91bad1a18276e60f1d8e1e66fa44bfea6192ec95bc46f41a01"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e906f978ed82c31e7f80aad00925a48d16bd17ebfe02825b21a80017e552d99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f58cf8d6656410d5f2e2467fe447906e3bd6092362c44fe4676fbb4e92fe2e2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f323569e700753a8e5b99dec6d70e774a6f462e2389b7d19c74248c73982946d"
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
