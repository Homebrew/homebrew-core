class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.74.tgz"
  sha256 "cd51b370cbb11498225abbf3319069a425482e980eae461ed4a6d03b23902f6d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1df8334512e7a8a3bf8164b667eb8512ed6caaf4684e0763b8793233705c097c"
    sha256 cellar: :any,                 arm64_sequoia: "4518dd442e0c459d245328ea40282561a2d0ff34379a9f733e7a1e04c1ec9cef"
    sha256 cellar: :any,                 arm64_sonoma:  "4518dd442e0c459d245328ea40282561a2d0ff34379a9f733e7a1e04c1ec9cef"
    sha256 cellar: :any,                 sonoma:        "c119423f8e62e7ca704442b6315629e1033d2db709238b0ea47f7541992e840d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc5949a7abdac6f130c5480cfbf488d953eab790cad5670b5d1d9344aa2917ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4abd236834ac3f1198981cc2d7ba3752195804ee6248ccd2566aec721d87f06d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@llmindset/hf-mcp-server/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["TRANSPORT"] = "stdio"
    ENV["DEFAULT_HF_TOKEN"] = "hf_testtoken"

    output_log = testpath/"output.log"
    pid = spawn bin/"hf-mcp-server", [:out, :err] => output_log.to_s
    sleep 5
    sleep 15 if OS.mac? && Hardware::CPU.intel?
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
