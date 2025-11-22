class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.23.0.tgz"
  sha256 "9e792dc49b3dade3e36cb76e66b7c87f4a5e22d7bbe80713de47aca56f5daf92"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c032eccca5ce1245184a802412b6312b06a56ca627100abc6d04a87dee86bd1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1b972c4ca8931063a246bf80f6e182914251fcf5587e8caff5a646790c4d1e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0366bd2f8e4ee71d4631f2cd84a1fe70c5ac2bd855c37172600a0ccddd3afa5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "40a157833def661df69b59bf223d8b778349524430cd69ca5f9ecc64357e7232"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "602f9c470932d87f7038cbd78648b693affe7698a4b93290e716afa937ab41ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "244a99537d0e8613c426be607144276efc51be72baee80ad5aa42b2231d2e12c"
  end

  depends_on "node@22"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["N8N_API_URL"] = "https://your-n8n-instance.com"
    ENV["N8N_API_KEY"] = "your-api-key"

    output_log = testpath/"output.log"
    pid = spawn bin/"n8n-mcp", testpath, [:out, :err] => output_log.to_s
    sleep 10
    sleep 15 if OS.mac? && Hardware::CPU.intel?
    assert_match "n8n Documentation MCP Server running on stdio transport", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
