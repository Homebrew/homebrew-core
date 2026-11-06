class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v1.13.0.tar.gz"
  sha256 "7f4a2ba841673ae31c8e48003f1ef2d0a5034f8e5fb734e3e57d9dedc3bdda8c"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e4fd5ae332805f354a008edb2a525bf9c443c4bd4f9e7a2da8a9ab81870486b7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e4fd5ae332805f354a008edb2a525bf9c443c4bd4f9e7a2da8a9ab81870486b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e4fd5ae332805f354a008edb2a525bf9c443c4bd4f9e7a2da8a9ab81870486b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "20105bd6ad0168e59b7119fe6e488b318864da781671c95e45955abdfcb167f5"
    sha256 cellar: :any,                 x86_64_linux:      "8b776848b50aee6bd92d403d78e664e48a33ce3b7726ee183a797c452f7ecbf8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    # Read the reply before closing stdin: 1.7.0 exits non-zero on EOF without flushing
    output = IO.popen("#{bin}/gitea-mcp-server stdio", "r+") do |io|
      io.write json
      io.readline
    end
    assert_match "Gitea MCP Server", output
  end
end
