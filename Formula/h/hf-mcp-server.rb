class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.8.tgz"
  sha256 "fd223f327ef4c12729e87f0045137e8bc5fba494bad7c9a8548f23463158c6f7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1aef16dc61163a36f0b74b49778ded5b021f1d7c716ece831c273071b3671ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1aef16dc61163a36f0b74b49778ded5b021f1d7c716ece831c273071b3671ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1aef16dc61163a36f0b74b49778ded5b021f1d7c716ece831c273071b3671ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "2906c6015938ff8de5635fb55b2c028c3aa9fc467b76d56695b4bd7d35013bcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13fb56fb34135a2090b9cb9db60a691c8e50ad0e0c5a09eda18427ccbfb640e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13fb56fb34135a2090b9cb9db60a691c8e50ad0e0c5a09eda18427ccbfb640e8"
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
