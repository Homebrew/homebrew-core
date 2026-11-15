class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.34.tgz"
  sha256 "44dbffeb175a4db3def8d8681960242eddd05d422917ddf6240c3b000d745d19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d60c00595b08aa9c81430ad3acc2481e9367e90b452a7c7cf0c109501b23acbd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d60c00595b08aa9c81430ad3acc2481e9367e90b452a7c7cf0c109501b23acbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d60c00595b08aa9c81430ad3acc2481e9367e90b452a7c7cf0c109501b23acbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e98bbf0d0a785ebf1c9e910532bc9e3dd8d88900af59a273002455d2fc80f7c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e98bbf0d0a785ebf1c9e910532bc9e3dd8d88900af59a273002455d2fc80f7c7"
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
