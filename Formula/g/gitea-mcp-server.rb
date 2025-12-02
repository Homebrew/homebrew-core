class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v0.5.0.tar.gz"
  sha256 "639ae3145719f5bff86d32a85f499bfdf42c9e1ed785c96d208e3296d650fa0c"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fff1bba5dda4d0d45aef7c893d8f3fa48f6c00ddf0420c2375b75968cb871702"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fff1bba5dda4d0d45aef7c893d8f3fa48f6c00ddf0420c2375b75968cb871702"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fff1bba5dda4d0d45aef7c893d8f3fa48f6c00ddf0420c2375b75968cb871702"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea34e8fae4a3eb1bb9b4946f4942cfd738997295efd0c9cb9aae40723c932f49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e02e8269d272cbb93372c285fad399ce5f4b3024229afcc72ca8dc2216c9607b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e3a9885b6e2967883a68636874af5f01ebc74489f94f681b4518859c5dee441"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Gitea MCP Server", pipe_output("#{bin}/gitea-mcp-server stdio", json, 0)
  end
end
