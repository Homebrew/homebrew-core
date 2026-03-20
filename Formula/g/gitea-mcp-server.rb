class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v1.0.1.tar.gz"
  sha256 "8c9177bb25dfd966d1bcc855eb7121dfc2640c45518a6a423b849c39f53bffa7"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cfba6b01ecc33ad9a31c914f55592883385f789fbde3d63e08b4b5fcd5c5e10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cfba6b01ecc33ad9a31c914f55592883385f789fbde3d63e08b4b5fcd5c5e10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cfba6b01ecc33ad9a31c914f55592883385f789fbde3d63e08b4b5fcd5c5e10"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8a183d9a95c1a48e19e1857f5ca87b71b2d6b24430c7de1364b88975e3ba623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67e169a890cdc315fdf00e019926c41f5fc0bc7d27dc0007f4d62a05af029378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03e9571255c0f6c693ea2aeb00cbb9dd7215a55bbb376b4c7bb12c4fb9459f59"
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
