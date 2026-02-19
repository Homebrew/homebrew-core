class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-3.2.1.tgz"
  sha256 "86f201e261f087bd77f9ba0cdd110cb5367e10d48ab1691afebd12d4bcb433af"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f0147511af79099a5dd103767ab5344112fa1cf70891f5740c48ba9248e249e3"
    sha256 cellar: :any,                 arm64_sequoia: "869282346ad9948c99e7f3a534b7965f944a898fc15c1b3d26352832d898c3c2"
    sha256 cellar: :any,                 arm64_sonoma:  "869282346ad9948c99e7f3a534b7965f944a898fc15c1b3d26352832d898c3c2"
    sha256 cellar: :any,                 sonoma:        "7a6027b9e6c9e243442ebd4017c9e8a600714e1169c53a2bc7ba3ed4633b1316"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee5be93194a5d2f5e40059c5a23bf941a9e3855d3685c9eb9e44a98e5f8e3652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04a56710823bc929196eaa8a22218b8a4517c81d5e6272779e9cf1b6b7f52b28"
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
