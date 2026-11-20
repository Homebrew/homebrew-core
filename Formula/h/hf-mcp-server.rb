class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.38.tgz"
  sha256 "27baaa374a04e19594962b03728e234d8b438705502c1b3ab391748d51a1bb03"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2df0d6bf2c53a37d857a710507fe5a3936efb86cc88fa1b1e492b245aabd9249"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2df0d6bf2c53a37d857a710507fe5a3936efb86cc88fa1b1e492b245aabd9249"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2df0d6bf2c53a37d857a710507fe5a3936efb86cc88fa1b1e492b245aabd9249"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2f0bb380b1d395c88194bc8ec96dbd15dc2f631bb378b0fc980b4e39d77bc9a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2f0bb380b1d395c88194bc8ec96dbd15dc2f631bb378b0fc980b4e39d77bc9a3"
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
