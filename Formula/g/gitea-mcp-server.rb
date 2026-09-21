class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v1.7.0.tar.gz"
  sha256 "1ebf82dfc7ffafeadeec9bc8a28d628c86a440008f4f1b75678191bbeb074948"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "451e84dfbc45ae6b0ecb025b21de69459cad5a62e3e7543e47e1570d280d1313"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0bd199a4112f405777cb0370ed4ac91199d540f1d3499513a4d03d501e686e9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0bd199a4112f405777cb0370ed4ac91199d540f1d3499513a4d03d501e686e9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "0bd199a4112f405777cb0370ed4ac91199d540f1d3499513a4d03d501e686e9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3993b89763ddeaf62c8254d9d15bce009d954924ee57e46f616cd262c3c66bc3"
    sha256 cellar: :any,                 x86_64_linux:      "9d82a9e7bdd64016c1a5f7e2fd4ad70825576e84661f891ff7c33f908f02d5dd"
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
