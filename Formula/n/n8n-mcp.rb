class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.18.4.tgz"
  sha256 "8028cecc47fd46fd824c1bfd6045e7f2dc9c4d3d78b7c6786cf7b74ec99321ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc6e4dc6d02e09b3a8ba49b49398c3bd066b222ef917c26312ac11e535e9bd48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02cfcceda2749b23bede05110c6ab835fb5ebd014b809c903eade5ff29ab10a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "299df0236e778c2e7b2a28ca3b4506da7842e784ff3fa8d1a58a3d4322ca57f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c623d1ec26e82b805db847666b4ed5085b1614574858d27e1fee421ad7628e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "159cbf72ff68821d3f30944849d859a13266fecf4d2d6c1851c5a53fe38ee1a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2410d53ea432858052aa3cdbe0be520854562bbb56a8133dbdfa656628f7d0c6"
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
