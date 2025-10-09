class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.18.4.tgz"
  sha256 "8028cecc47fd46fd824c1bfd6045e7f2dc9c4d3d78b7c6786cf7b74ec99321ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ae80ac39611493c8daf9b1dd32db504fdda03c1014b019b774fc1f0095e3558"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9616b4fc82e609825245919e3f33516fa9952e310d5c79632cc13cd4daaff42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4be90c56e660f2d2184b64047831d4e04416cc5d051db41959ef8a7c3069ab5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1b6f37aabfe872edbeed51b31cbf8d30d5fcad7ee80d907420db23afdc0da7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2742f3c41faa3e441a2c44f92acfb2c00cdb9dd6a760694839d0b3b21baa2895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "266afc1414ca68746c9053fb9f77af00a1f571e20cd9cc1d661054cb121ba95e"
  end

  depends_on "node"

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
    sleep 5 if OS.mac? && Hardware::CPU.intel?
    assert_match "n8n Documentation MCP Server running on stdio transport", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
