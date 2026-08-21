class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.10.tgz"
  sha256 "6e57f7fabf7efa92f1d181015117bcb7895f50394f86cbca34464d63b2f5f9ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62034fa29764ded98b7212b31ee22761a51100c42c58b60638490cecaa2abccb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62034fa29764ded98b7212b31ee22761a51100c42c58b60638490cecaa2abccb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62034fa29764ded98b7212b31ee22761a51100c42c58b60638490cecaa2abccb"
    sha256 cellar: :any_skip_relocation, sonoma:        "66412d7d4ee57d7bc85f829e9309ac9413ea6528b84589cafc03bdeb8b30ed7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7716727828ff5363dabeead95dbf50f78bd93cbfb5f04681c75353521824cf22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7716727828ff5363dabeead95dbf50f78bd93cbfb5f04681c75353521824cf22"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@llmindset/hf-mcp-server/node_modules"
    # Remove incompatible and unneeded Bun binaries.
    rm_r(node_modules.glob("@oven/bun-*"))
    # Remove dev-mode-only bundler and CSS-toolchain prebuilts.
    prebuilts = %w[
      @rollup/rollup
      @rolldown/binding
      @tailwindcss/oxide
      lightningcss
      vite/node_modules/lightningcss
    ]
    rm_r(node_modules.glob("{#{prebuilts.join(",")}}-*"))

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["TRANSPORT"] = "stdio"
    ENV["DEFAULT_HF_TOKEN"] = "hf_testtoken"

    output_log = testpath/"output.log"
    pid = spawn bin/"hf-mcp-server", [:out, :err] => output_log.to_s
    sleep 10
    sleep 15 if OS.mac? && Hardware::CPU.intel?
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
