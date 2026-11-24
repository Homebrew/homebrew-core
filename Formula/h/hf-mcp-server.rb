class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.39.tgz"
  sha256 "b47a785857984c9fc1688e0fd68b439a579abaad50fbaf5337bd7fcea6f22ab6"
  license "MIT"

  bottle do
    manifest_sha256 "a697608698458e1ff0f1e4780d044e85ade8e7328b015225286530e552adb0f0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "29c8712c5f180bfef9a5c21c2c748006734876a3941fe360d5b93634e09e075d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "29c8712c5f180bfef9a5c21c2c748006734876a3941fe360d5b93634e09e075d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "29c8712c5f180bfef9a5c21c2c748006734876a3941fe360d5b93634e09e075d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ecff65647db9cd8e0b8465ab37dfe5f3086e5740551e6547f4c1d0cec59a2109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ecff65647db9cd8e0b8465ab37dfe5f3086e5740551e6547f4c1d0cec59a2109"
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
