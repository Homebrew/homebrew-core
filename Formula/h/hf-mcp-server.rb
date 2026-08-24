class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.12.tgz"
  sha256 "e7b62bcd2fef748c652effd4d1debff41085af843734051dafa8b336280b75e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "850455f3f6adf63f61b3a3690b034c676bbb5b7d1d1abb89e606f00364a4eeae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "850455f3f6adf63f61b3a3690b034c676bbb5b7d1d1abb89e606f00364a4eeae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "850455f3f6adf63f61b3a3690b034c676bbb5b7d1d1abb89e606f00364a4eeae"
    sha256 cellar: :any_skip_relocation, sonoma:        "04593c62bbc94f96c95be59cddaa1b77c497a50b783ef530770dcaa5f263c0ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "536db7c076b5e755ed2c4fe919edaaee70ed40c8211dad5d1f5bc23c25c34fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "536db7c076b5e755ed2c4fe919edaaee70ed40c8211dad5d1f5bc23c25c34fa0"
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
