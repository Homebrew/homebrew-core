class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.37.tgz"
  sha256 "da5f1ea877d71642907ed2e2e135557be7c5c6d7f4c3b587427835867537a84b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cc28a66ce5b99cd9706a5f89262c78eb9e483eed08026e058cc1d2cc7bea89dc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cc28a66ce5b99cd9706a5f89262c78eb9e483eed08026e058cc1d2cc7bea89dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cc28a66ce5b99cd9706a5f89262c78eb9e483eed08026e058cc1d2cc7bea89dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "55f2160f6b960168eec937bc7d7c3a2e964b8e605ec599072470e4e7795e2f01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "55f2160f6b960168eec937bc7d7c3a2e964b8e605ec599072470e4e7795e2f01"
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
    # The first `node` launch on macOS CI VMs can spend 20+ seconds in dyld
    90.times do
      break if output_log.read.include?("Failed to authenticate with Hugging Face API")

      sleep 1
    end
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
