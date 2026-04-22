class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v1.1.0.tar.gz"
  sha256 "2dbb255f28a68d5489251164acf930bce803f5d16836dcc50c0c004864dbf826"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38f0b6d12b3536ae3cc565705c9b62c1f79888ea3704286e2d8b4cf591c76e45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38f0b6d12b3536ae3cc565705c9b62c1f79888ea3704286e2d8b4cf591c76e45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38f0b6d12b3536ae3cc565705c9b62c1f79888ea3704286e2d8b4cf591c76e45"
    sha256 cellar: :any_skip_relocation, sonoma:        "548fdbb7ea3e3beba9475d26ce6eca7669556e2bca19ad3a115326f36452fc92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55ed2dd1ea5317c4cbf09fb476493eeee64e7b01b504e453e62eb5a6120e0558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce74ad87d08a9e8f5ec4a6d063967441e9383b8c61f2fde16a23aa9000c49a23"
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
