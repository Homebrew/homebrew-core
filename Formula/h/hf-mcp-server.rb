class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.20.tgz"
  sha256 "79c45fe703ab2c5f46b8d80f9f97f8164b6b4b43696aed507ddb7df1ccdc1402"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b258aafcccfeec318752e20d874d604807a436f11eb835c4caf0b8d8e7357d9c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b258aafcccfeec318752e20d874d604807a436f11eb835c4caf0b8d8e7357d9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b258aafcccfeec318752e20d874d604807a436f11eb835c4caf0b8d8e7357d9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2bffacce9dc995ccbe199e28381a911f98e5b0ca56c31d5d87b5ac0be4ec1fc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2bffacce9dc995ccbe199e28381a911f98e5b0ca56c31d5d87b5ac0be4ec1fc4"
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
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
