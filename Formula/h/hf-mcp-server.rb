class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.34.tgz"
  sha256 "b752a8a61ab8a74f659988a77fba10f7405c64dac35d18f13b057eeb80678dc8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7a006230c7eb032e49279b679f6c0c64169ec63165c21a36e8974fdae445e97c"
    sha256 cellar: :any,                 arm64_sequoia: "e4a60613a437aafea1ef8d9bcf07169da90b3a385a95442709705566fcbda5de"
    sha256 cellar: :any,                 arm64_sonoma:  "e4a60613a437aafea1ef8d9bcf07169da90b3a385a95442709705566fcbda5de"
    sha256 cellar: :any,                 sonoma:        "c6fee5d93307a635a7358747993bbab299e92e9173d2d428262634220b5e7057"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a1bf926f6e7ab3bbfbf56b8ef399074ed008fa00ec9da591dc04e4138b106ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9ff86c5fa699ba53200f2aa8669acbb7124fbdff2e63d830678ae63bab61a1f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@llmindset/hf-mcp-server/node_modules"
    # Remove incompatible and unneeded Bun binaries.
    rm_r(node_modules.glob("@oven/bun-*"))
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["TRANSPORT"] = "stdio"
    ENV["DEFAULT_HF_TOKEN"] = "hf_testtoken"

    output_log = testpath/"output.log"
    pid = spawn bin/"hf-mcp-server", [:out, :err] => output_log.to_s
    sleep 10
    sleep 10 if OS.mac? && Hardware::CPU.intel?
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
