class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.33.tgz"
  sha256 "f2a6111fe59ba650c07b391205776b24bde2f03b88ee15d643cf58c0e901a58a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "84d07c5dcc28b5bfe57c014901eb3ea1e38252eec9001241afb0b752d5a48d6e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "84d07c5dcc28b5bfe57c014901eb3ea1e38252eec9001241afb0b752d5a48d6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "84d07c5dcc28b5bfe57c014901eb3ea1e38252eec9001241afb0b752d5a48d6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5fa89b0d72e2a2e67e7bed56a21115504f123902b70fbe59b45ba539c785de42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5fa89b0d72e2a2e67e7bed56a21115504f123902b70fbe59b45ba539c785de42"
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
