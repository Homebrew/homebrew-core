class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.35.tgz"
  sha256 "921dd8d46cfbcc0b91e5a9559864bd65ef26f4d5897c4a383d598b8426325319"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afee925abb1aafa56f0b836f5207d2528477277cf537e2624d67a68b0b814c8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afee925abb1aafa56f0b836f5207d2528477277cf537e2624d67a68b0b814c8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afee925abb1aafa56f0b836f5207d2528477277cf537e2624d67a68b0b814c8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f23228b4a87f086cb575314e4a2167a669d6a654ddf340fcfe57ea54b4a2292e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94df73478981b0f3f60b2b783ac747c4d8122b67c399a95e505b2bb5a1fd005f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94df73478981b0f3f60b2b783ac747c4d8122b67c399a95e505b2bb5a1fd005f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@llmindset/hf-mcp-server/node_modules"
    # Remove incompatible and unneeded Bun binaries.
    rm_r(node_modules.glob("@oven/bun-*"))
    # Remove dev-mode-only bundler and CSS-toolchain prebuilts.
    rm_r(node_modules.glob("{@rollup/rollup,@rolldown/binding,@tailwindcss/oxide,lightningcss}-*"))

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
