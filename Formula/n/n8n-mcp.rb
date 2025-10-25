class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.22.5.tgz"
  sha256 "bc0e215e45d258244bd7af1c57b051a8caed17258047f2a9361cfdc766305f6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d01b45ef38f16f246dad9dfae463ff50184ce518b1d152f4328926ac40aea1b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57d8673ed02d47f5761305a582667dd0701cd45e6455a8d29e685b24b98bbb82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e53779d56f25507f26e38db43179a9987a60cf5516ea4740fa900d4ee6716967"
    sha256 cellar: :any_skip_relocation, sonoma:        "fef736a117a55c610cf2d5e93595cbaf62a07f078bfa7f0d9976fb79037b2e20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d78f0265f338deb0a5ac91e78665477314e2f6e1ea2b5f3b661ca8ab1544b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4237bbfba8023512658fbb3bf1b6721f8aaaad29b9cfbaab711bf89fc45606cc"
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
