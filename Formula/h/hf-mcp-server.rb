class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.31.tgz"
  sha256 "13d9071e45e5eba3067c01382f671f45011f6b197b8fe98182286f6e1853e878"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7562b754d791d59637ffb86a8daacdc8c3eb6aa49723fee1eb95e13fff611180"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7562b754d791d59637ffb86a8daacdc8c3eb6aa49723fee1eb95e13fff611180"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7562b754d791d59637ffb86a8daacdc8c3eb6aa49723fee1eb95e13fff611180"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dc61e7698b9632aeb30ccee1a290bda1ed87298bccae5724fd814ee50701210c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "dc61e7698b9632aeb30ccee1a290bda1ed87298bccae5724fd814ee50701210c"
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
