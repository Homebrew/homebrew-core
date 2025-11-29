class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.27.0.tgz"
  sha256 "56f9bf7fda768fffb6f7c950697c5cd3c4af82a8e07e0b99d2b830c2e29e8a7d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82b58264ffa40825e41acd7e35a8de408ffa46c74ecc00c21b80e117e8d6cdac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6cd33fb795821ed3288b079a1ca17047463cb42642ca76ec49c5850f6fd8b90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8b59d134702852403bf8f72eaed7595e13817434e7a5cec7dfaed1a45320f88"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8b59d134702852403bf8f72eaed7595e13817434e7a5cec7dfaed1a45320f88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06699def093834864217466921835b09e6c12909401d95e690fbe44d4aca5d62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39d9509d3856f31a78652c87dc861fcbd396feb525dba74aad40eca0806e8cf5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
