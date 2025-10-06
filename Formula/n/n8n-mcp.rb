class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.16.0.tgz"
  sha256 "86cf3211d6f67d5e315158914bf2570a992304bb800450037580124db75e2121"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "065171c9c8adba817d6e1f6e99814d030e354255a426ad0c614c664fca65e794"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "279a5b78961cbe7ad3f32b3aa2a0b4decc57dd7d7bea7824284466655a1e6892"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00130919f10394807824253473c79824bb7d31ed7b04962efac4f6380923e457"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab08891065a46fcb9de46309d010cad86b51639cfcf5a92fc383c7d40239da0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06cbc54cfadf932371dc08325b6599f8df4b720ac91c2ce177fa1e494f02fe49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e158fc2f8faf4eb6696bdff1515ba4778d5fa2ac04d43906026fe6ffe1da804"
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
    assert_match "n8n Documentation MCP Server running on stdio transpor", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
