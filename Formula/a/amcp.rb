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

    generate_completions_from_executable(bin/"amcp", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/amcp --version")

    # The management API catalogue ships with the CLI, so this works offline.
    assert_match %r{GET\s+/api/connectors}, shell_output("#{bin}/amcp api --list connectors")

    # Without a saved profile the CLI must refuse with a clear error and exit code 2.
    assert_match "Profile not found", shell_output("#{bin}/amcp whoami 2>&1", 2)

    # A server that cannot be reached is reported with exit code 4.
    ENV["AMCP_URL"] = "http://127.0.0.1:#{free_port}"
    ENV["AMCP_SERVER"] = "test"
    ENV["AMCP_API_KEY"] = "mcp_test"
    assert_match "Could not connect", shell_output("#{bin}/amcp tools ls 2>&1", 4)
  end
end
