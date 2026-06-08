class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.19.tgz"
  sha256 "2a9648f05a2b65c93393ae87cd685f059ebbdd77f0a975b6f938cebf3a430643"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b394830fd703a531d9acc17aa0268cf8ac70b2393fd55d58f0bc0971247ce00"
    sha256 cellar: :any,                 arm64_sequoia: "5b5e3d94a0307efb2022f72a2a098372f680c82e9ef7dba39f71b39b5585eac3"
    sha256 cellar: :any,                 arm64_sonoma:  "5b5e3d94a0307efb2022f72a2a098372f680c82e9ef7dba39f71b39b5585eac3"
    sha256 cellar: :any,                 sonoma:        "9ca3a95b1cc6f441932558a93a54fc25fd150659050774f1ddf9aa0a8b5b2d54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "326086600e396879f8ff460dd750a0feab2764632dde361fc9adadae9c6dba88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9459f41bda88ccf1117a12cb4ac6b1e837da8dbb95fd28de9cc83a2b0df18c2"
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
