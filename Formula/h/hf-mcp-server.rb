class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.37.tgz"
  sha256 "da5f1ea877d71642907ed2e2e135557be7c5c6d7f4c3b587427835867537a84b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e85a63ea06c89a3604c0c32ee3b018d959c0617f4c3d164d937c1cbd1033088a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e85a63ea06c89a3604c0c32ee3b018d959c0617f4c3d164d937c1cbd1033088a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e85a63ea06c89a3604c0c32ee3b018d959c0617f4c3d164d937c1cbd1033088a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "52ebdbb19dfeefafc1d68e1e5bcfea2da63f67bb69691fc311bfb83319c2ca5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "52ebdbb19dfeefafc1d68e1e5bcfea2da63f67bb69691fc311bfb83319c2ca5e"
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
