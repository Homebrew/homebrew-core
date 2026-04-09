class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-3.5.0.tgz"
  sha256 "e5ea7438a535e3fe0790b66848366b9c12cf31ccf5ae4a077f52acc97b853d54"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b6bbeffddbb2969702168a77ce87aca1be105fb8313397d41d3ebf11cb910df8"
    sha256 cellar: :any,                 arm64_sequoia: "42093f51f8c758e837e2f482023a61a20f6f075fd444e7c500cdcc89decf384c"
    sha256 cellar: :any,                 arm64_sonoma:  "42093f51f8c758e837e2f482023a61a20f6f075fd444e7c500cdcc89decf384c"
    sha256 cellar: :any,                 sonoma:        "412248518b902401a2db6f88094e30efdb6fe965a77ae3f901c76012729de84f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60cb599a84e409258ab9b20bc6c0d636d8e2505a1c8e865b6c0b868646cff68c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d6a7ea0d9d06c7b63fe798220d20d08fbf580ae6a0a576cb5c85c9608661e0b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/mcp-server-kubernetes/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON
    output = pipe_output(bin/"mcp-server-kubernetes", json, 0)
    assert_match "kubectl_get", output
    assert_match "kubectl_describe", output
    assert_match "kubectl_logs", output
  end
end
