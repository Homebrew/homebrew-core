class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.22.tgz"
  sha256 "2fd6adbd68626845d947d8c14d725abba11f50e424666794510086a92e6460ab"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aeb42d421bf51e896ced00e49ec07e426f82ea747edd88fc81c5a9a5e23b8942"
    sha256 cellar: :any,                 arm64_sequoia: "c4474d3cab6552bcbf33c33d8b25e8d89891432a7212770ab531a6a3b53526d4"
    sha256 cellar: :any,                 arm64_sonoma:  "c4474d3cab6552bcbf33c33d8b25e8d89891432a7212770ab531a6a3b53526d4"
    sha256 cellar: :any,                 sonoma:        "4bc8bc9a8e5edb6a7862b2b1233344fff23bcc2d3c0a25bbb52de9ae9c95c93e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c784bf4f3cb5460ddbbaf4ea787d695713b2c8fb8136db8bba2a6de6f0ce9cd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac1ff5dd66d009c1fff4d526e2d99a0e0f6cf24e7f7066d7cb7619879f1eeab6"
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
