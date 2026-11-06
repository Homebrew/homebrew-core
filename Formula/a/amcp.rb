class Amcp < Formula
  desc "Command-line client for AnythingMCP, the open-source MCP gateway"
  homepage "https://anythingmcp.com"
  url "https://registry.npmjs.org/@anythingmcp/cli/-/cli-0.1.4.tgz"
  sha256 "aca188b9160b1b84d934f4cc7a35c3263ef6514af9a4aadcb42fdb463163f319"
  license "AGPL-3.0-only"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/amcp --version")
    assert_match "amcp", shell_output("#{bin}/amcp --help")
  end
end
