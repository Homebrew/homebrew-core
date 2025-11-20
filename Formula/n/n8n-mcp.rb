class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.22.21.tgz"
  sha256 "fad64148feadfcb8214a550beb699ef3a4015be7a6f57f14615ed658b4cc185c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7890e807c5b32de4dc3f4022daad3738ecb23f4b9d70315584268cab23d27ea3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "225588c6b65ee2305d722d2c11c2087d1f344b434aff3d308ab2e15bdbd5ac34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b86a2f14fd6fabfb835bfb2758331e3b3dc51468adb9a76990f6d32dac4da898"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a21e283fb6593c15aaf9ee2bb3a61cc17d451cbff755bf3745fcfd071b316ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a59d00916e630e80cb5fbc896f0742462c13825d36b79141928d5dfdfe4b92f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "253ad1468348bec29e029155c0792b07f0237c056e09f0d2d5f8d83e9b60c1ff"
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
    sleep 5 if OS.mac? && Hardware::CPU.intel?
    assert_match "n8n Documentation MCP Server running on stdio transport", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
