class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.5.1.tgz"
  sha256 "65e46c888a22b2d2b5690fe992ef6d8c6ceb3258cfb4addb59e89f9963b8c8ab"
  license "MIT"

  bottle do
    manifest_sha256 "8b5b3bddbb6fa609bc615614ba6a4df685c9752c1a0fa5b1b946265353cb7402"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e16e3286fc4c481592601deefb2e1e71aca6b3902a0ce8b0fcc214f5fea0d7c1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e16e3286fc4c481592601deefb2e1e71aca6b3902a0ce8b0fcc214f5fea0d7c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e16e3286fc4c481592601deefb2e1e71aca6b3902a0ce8b0fcc214f5fea0d7c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2682c7a9670bea6e7a5d039a14a1f75f24d6ae3afa31e134d7d0ba00fa02b472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2682c7a9670bea6e7a5d039a14a1f75f24d6ae3afa31e134d7d0ba00fa02b472"
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
    with_test_process(bin/"hf-mcp-server", [:out, :err] => output_log.to_s) do
      # The first `node` launch on macOS CI VMs can spend 20+ seconds in dyld
      90.times do
        break if output_log.read.include?("Failed to authenticate with Hugging Face API")

        sleep 1
      end
      assert_match "Failed to authenticate with Hugging Face API", output_log.read
    end
  end
end
