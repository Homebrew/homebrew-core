class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.55.tgz"
  sha256 "9f2b576a9989db7c6c2f8f5f8d831e9b564656a05a13b0d0b38696cda226dd33"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "62d1d8a494e53d21437963544e9a0c5c71747b74c1804f83b3e13c0f29e3b76f"
    sha256 cellar: :any,                 arm64_sequoia: "6dd2336f70c8be766101bf5cfd2b682f3d54de77c86ea1f40e1ec7185a1fce80"
    sha256 cellar: :any,                 arm64_sonoma:  "6dd2336f70c8be766101bf5cfd2b682f3d54de77c86ea1f40e1ec7185a1fce80"
    sha256 cellar: :any,                 sonoma:        "16af807ce13855c8090c0b0a66a727b8d3207aeeb3733caf5dacc6ce77ea3095"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7dccd90895e24900888e937fab35c19fdacec1e54d9e3d96bf1d5e134307f51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a6f945fb764d6d3ce03954d9a116ad2378bb33519c5fd2a27a69562b76093ca"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/@llmindset/hf-mcp-server/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["TRANSPORT"] = "stdio"
    ENV["DEFAULT_HF_TOKEN"] = "hf_testtoken"

    output_log = testpath/"output.log"
    pid = spawn bin/"hf-mcp-server", [:out, :err] => output_log.to_s
    sleep 5
    sleep 8 if OS.mac? && Hardware::CPU.intel?
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
