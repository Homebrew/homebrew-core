class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.12.tgz"
  sha256 "33fe87873926e979e85c8b2e5c09ccefa56d21610d393b1b4135619bed933ded"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8431347afee04babb56b27e38ad80cb36d2944d34654e59039b22b65fada7eaf"
    sha256 cellar: :any,                 arm64_sequoia: "e3ff195703845bb351d0937e9c2eb4c5fbc0ddffc75e69348582f8a97905fa3b"
    sha256 cellar: :any,                 arm64_sonoma:  "e3ff195703845bb351d0937e9c2eb4c5fbc0ddffc75e69348582f8a97905fa3b"
    sha256 cellar: :any,                 sonoma:        "9a1cae41ef8c05075bbfa30b6cafcc0d784054a5046c77408d47906b49c2a112"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6395633adb03d3823050a00b40b629d7a5e886fe88202772fbc062918413a957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c4a27af1b44c5b9521d57578800d7ddcdd7c296e312a7950c8349b575916df4"
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
