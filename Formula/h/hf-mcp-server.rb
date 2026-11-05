class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.33.tgz"
  sha256 "f2a6111fe59ba650c07b391205776b24bde2f03b88ee15d643cf58c0e901a58a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3d8dcc6344035b92ae7e87758f6ccf89360f1ed662286fc724e3c74fa30d9a8b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3d8dcc6344035b92ae7e87758f6ccf89360f1ed662286fc724e3c74fa30d9a8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3d8dcc6344035b92ae7e87758f6ccf89360f1ed662286fc724e3c74fa30d9a8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a1c5877c814dd9b076c018c97edcb11b6778b22b56d65a7821d2c9489e480000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a1c5877c814dd9b076c018c97edcb11b6778b22b56d65a7821d2c9489e480000"
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
