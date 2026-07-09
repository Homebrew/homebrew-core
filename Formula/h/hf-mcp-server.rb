class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.28.tgz"
  sha256 "cd8143c32c0cc7e24879ce9c6273b04d120ae5ef6ae996dbbbf5fdc369db3dfa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "29c493a8f80bf21832edd5809ba837ff1ffc2ce2a869cf9f9c02862d93fddf1d"
    sha256 cellar: :any,                 arm64_sequoia: "d6736b4f0782643c0e7c84cad9f776f4db550697b9c6da7cec4f6e6528061939"
    sha256 cellar: :any,                 arm64_sonoma:  "d6736b4f0782643c0e7c84cad9f776f4db550697b9c6da7cec4f6e6528061939"
    sha256 cellar: :any,                 sonoma:        "bb424cd3abfbfb6fbc1104224e8e6ecba6c62f7ddd3dad1daf5f4d4709c13a5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed49b629266b400cb64e55fb9675df8b6f276fea529c528d3579504c21e7bb27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "140cfe7a01bcb3db62103a1315d41083498a3c59f1c957067f902a97c6344eab"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@llmindset/hf-mcp-server/node_modules"
    # Remove incompatible and unneeded Bun binaries.
    rm_r(node_modules.glob("@oven/bun-*"))
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["TRANSPORT"] = "stdio"
    ENV["DEFAULT_HF_TOKEN"] = "hf_testtoken"

    output_log = testpath/"output.log"
    pid = spawn bin/"hf-mcp-server", [:out, :err] => output_log.to_s
    sleep 10
    sleep 10 if OS.mac? && Hardware::CPU.intel?
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
