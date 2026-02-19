class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.2.tgz"
  sha256 "f46108d653dae291295a6265ca036fc8be49723194f39181f34b0ccc12b81d1d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5995d74732c512d0802836f7712c47feb5a364426e4c79dc3ebe5bd475a089d6"
    sha256 cellar: :any,                 arm64_sequoia: "9f0887bfbb0f28f699eef75ce53f24e89c5dca105ba796d1540d8948d8794440"
    sha256 cellar: :any,                 arm64_sonoma:  "9f0887bfbb0f28f699eef75ce53f24e89c5dca105ba796d1540d8948d8794440"
    sha256 cellar: :any,                 sonoma:        "339884dcc553d4b10f89674bb1bb1e737da222624fc0bc65a9dcdcf2bd8b7924"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1a93cc0b5979a44047c9d738ca6316881f2e20c1defc020dc38a1375c887337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "078d46af1184da7494424348a4946d3921ca7d48c42fde7ad87e80491dd2ad4b"
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
