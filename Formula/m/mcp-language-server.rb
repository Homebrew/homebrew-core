class McpLanguageServer < Formula
  desc "Gives MCP enabled clients access semantic tools provided by LSP"
  homepage "https://github.com/isaacphi/mcp-language-server"
  url "https://github.com/isaacphi/mcp-language-server/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "cc8a052d6c0283545edaf6d50e452660baa726bc18e76591680f9a611f9d2b48"
  license "BSD-3-Clause"
  head "https://github.com/isaacphi/mcp-language-server.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/mcp-language-server -lsp tee -workspace #{testpath} 2>&1", 1)
    assert_match "[INFO][core] MCP Language Server starting", output
    assert_match "[ERROR][lsp] Request failed: method not found: initialize", output
  end
end
