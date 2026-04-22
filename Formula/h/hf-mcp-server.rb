class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.4.tgz"
  sha256 "4cb07478f9112ae6d4724546588ff0fe9bd7f145aead21a442ddf123aae94158"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "499e3453d48921c8d059420e09b7ae45bcf56b85ef5ee91284e04f0bbb87a848"
    sha256 cellar: :any,                 arm64_sequoia: "389b69b265594f6a5992efd41051e95230c74e90d17990bff0848a153ac0f188"
    sha256 cellar: :any,                 arm64_sonoma:  "389b69b265594f6a5992efd41051e95230c74e90d17990bff0848a153ac0f188"
    sha256 cellar: :any,                 sonoma:        "1d5a97ede99656023e396b907dbb815e68fba72ded2636b62efe796688dade26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee2c1757c6ebcce03ed1c203a62933cb005d994f4e9a781e3ed22e28b6fecfa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70a4fb3fcfccb80f3d2ea255e460feab3d87a3e46fa164630b5248dd9fd75c90"
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
