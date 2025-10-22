class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.20.8.tgz"
  sha256 "f0e0eaaf84999e71155d0fc33b63bd7129f6d1354af1119624aa47517781c991"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8cf6af86f54784a4042a01308ba69a814ee88a318bd2ec2e7dc1ba8a814be4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0bbe2f728545fbf5ce1caa878ea24f3476eb9f45f7a665aac0df83ca98f9300"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1d6afaefb77c094649dceb5894b85ebf61607c64b29bde15d4834cbbace0c52"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e5653f296fa00d2bf64da262426193ef4afdb20230ee769d229a22469227d34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31d03a0275192816399330eb73d10555409c56509238a030853576504e631530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "767054e78c0b4eecfaa0f84dd37b0600d4622f91cddf5d2871330f4cf60acd16"
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
