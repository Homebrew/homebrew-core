class Mcpreg < Formula
  desc "Pleasant-to-use command-line tool for the MCP Registry"
  homepage "https://github.com/trose/mcp-registry-cli"
  url "https://github.com/trose/mcp-registry-cli/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "8485f3957c4e2b0496f26204dfdddeae7c96167fd862a858b8370da71d1d5b77"
  license "MIT"
  head "https://github.com/trose/mcp-registry-cli.git", branch: "main"

  depends_on "jq"

  def install
    bin.install "src/mcpreg"
  end

  test do
    # Test basic functionality
    assert_match "MCP Registry CLI", shell_output("#{bin}/mcpreg --help")
    assert_match "version 0.1.0", shell_output("#{bin}/mcpreg --version")
    # Test that it can run without errors
    system bin/"mcpreg", "commands"
  end
end
