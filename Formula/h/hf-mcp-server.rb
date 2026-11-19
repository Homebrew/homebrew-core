class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.36.tgz"
  sha256 "5884989c2385706943d8802a71104609a78a5c44766712d984c2304cefc70c21"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8df37c4cdccaa7740490e27383e12abbc0b0f0b884ad267d4a15f3a92d402cfa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8df37c4cdccaa7740490e27383e12abbc0b0f0b884ad267d4a15f3a92d402cfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8df37c4cdccaa7740490e27383e12abbc0b0f0b884ad267d4a15f3a92d402cfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1c5471cc532ca68a207c249d0884a03fd8c25e38c79e7dd9b472de55ce993f3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1c5471cc532ca68a207c249d0884a03fd8c25e38c79e7dd9b472de55ce993f3d"
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
