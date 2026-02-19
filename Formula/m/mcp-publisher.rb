class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "c1e0745051316cae0ef9e7e4efaa9a636dad8fda8b14886ed220b3968b45e930"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "feb68e9c1b60b800aad744ea037b354d8fe9a43e4900954cd36883909d03253d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "feb68e9c1b60b800aad744ea037b354d8fe9a43e4900954cd36883909d03253d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "feb68e9c1b60b800aad744ea037b354d8fe9a43e4900954cd36883909d03253d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f72d38292c659e73faa3767f0c0c13c7fc9a548daa11e24ccae8568124f84fb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f97243e2c58d6252e0710650fd315d2d2c9249c266f2787f4bdaae6cced80662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c0bbf92c0e9edaf9b5dc3d32d39bc52f007382a9a96b9252a17d0e54a5d01f2"
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
