class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-3.9.2.tgz"
  sha256 "1f859b9ad884810f1e06bbaf5266e25cb387c02fa875d6f4f52958b7b318175d"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "64c2742ca1593c2b1b1173ac3b2a758135f3f2582d92ea55ecb7a51b9a2ee092"
    sha256 cellar: :any, arm64_sequoia: "1315a6a8f68807c6f6d5aab03cdeef1c2bc6d4bc7ea040464768841d831fc51b"
    sha256 cellar: :any, arm64_sonoma:  "1315a6a8f68807c6f6d5aab03cdeef1c2bc6d4bc7ea040464768841d831fc51b"
    sha256 cellar: :any, sonoma:        "5873d2eb03813ebe490e2aad90b2a1f30e858aa25c75cd7bf00e061c216ee093"
    sha256 cellar: :any, arm64_linux:   "830c295da53a146bd9826ed85d6188b962aa781b074eaaf93195a129d4b52476"
    sha256 cellar: :any, x86_64_linux:  "daef0d303958d16f18dd5554706d66c4366ce1c94e82f932622a63447355584a"
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
