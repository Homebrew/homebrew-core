class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v0.8.0.tar.gz"
  sha256 "fa24f77e649e43b6f2f78da42327ba836f0156cff5714d7b3c84d68d1a3c2874"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8615b0e3cc56b03187d0d20bb179736d5e3aeb78caffd00a54e26dd1861172a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8615b0e3cc56b03187d0d20bb179736d5e3aeb78caffd00a54e26dd1861172a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8615b0e3cc56b03187d0d20bb179736d5e3aeb78caffd00a54e26dd1861172a"
    sha256 cellar: :any_skip_relocation, sonoma:        "13dbfc8677784e354b85e7db8f63222220fbf6ef3832d737e8d95702ff5ab51a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71f53245969b47a238f99e5d9c7b5dbdd691b61510cce01df021673806c234e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b5f93db15205499aa38589a9e6367ad212353633117ffc429f7e1118ede1c9f"
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
