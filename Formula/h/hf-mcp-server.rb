class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.5.0.tgz"
  sha256 "9064cb03e0e7421398bf42fb4e42f9772a9d2809ddc28043be6c94b6d2f69286"
  license "MIT"

  bottle do
    manifest_sha256 "d317d336fd8771ec603968f38d8da5be8d37f7c9f05606e0ed6f6df3ef0b0cf5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "734e0af4497317105f4fc98a58ede012c6bce8de056b569f1988fa87c77c6019"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "734e0af4497317105f4fc98a58ede012c6bce8de056b569f1988fa87c77c6019"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "734e0af4497317105f4fc98a58ede012c6bce8de056b569f1988fa87c77c6019"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f8a4b14a7aeb6e92f27658fd6abd507424d101f6cfa0e3223cdaae9f8a4e8fd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f8a4b14a7aeb6e92f27658fd6abd507424d101f6cfa0e3223cdaae9f8a4e8fd8"
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
