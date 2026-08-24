class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-4.1.4.tgz"
  sha256 "290ccc8eddc31a70a25deec7e4b329d4982a3a8a368e265610088986b0177da9"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "de497759a60b2eeb52a2e80b3a7a4c0a4f52976f78e20cc86cd22eda09a13543"
    sha256 cellar: :any, arm64_sequoia: "de497759a60b2eeb52a2e80b3a7a4c0a4f52976f78e20cc86cd22eda09a13543"
    sha256 cellar: :any, arm64_sonoma:  "de497759a60b2eeb52a2e80b3a7a4c0a4f52976f78e20cc86cd22eda09a13543"
    sha256 cellar: :any, sonoma:        "b672e1c3471c846fb476ff528e274f38142967254a192da4c626615a9d83f1cb"
    sha256 cellar: :any, arm64_linux:   "853afb3a0b89572b694c7328e13838c565926d81dd98f51320e1fd605cf86d72"
    sha256 cellar: :any, x86_64_linux:  "e2769380c590c541aa331686b79152b386a80b3e46ba938ec9e619552bfdb627"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/mcp-server-kubernetes/node_modules"
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
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
