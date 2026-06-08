class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v1.3.0.tar.gz"
  sha256 "1339122b71e806806999f694ade323724d6eea2f86b86528c00660b28415e8ed"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6d116719a95c0850be5ba1b737916378e952997598912ed24a97ce59e1c5611"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6d116719a95c0850be5ba1b737916378e952997598912ed24a97ce59e1c5611"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6d116719a95c0850be5ba1b737916378e952997598912ed24a97ce59e1c5611"
    sha256 cellar: :any_skip_relocation, sonoma:        "79f36e92e4161ea61c072a16b78eb97bd7d72efe5a5cd8a4197b9c12246cb748"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a45d828bc58ac263267c3150c31d11adefd93ab80f447aaaf89b1d6881c2da9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ed0fc48edcc7e6e85bf265ce211803a9d3cccdded97a00f738fdc09d9dff746"
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
