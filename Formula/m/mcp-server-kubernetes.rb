class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-2.9.4.tgz"
  sha256 "90bda2f3ec49d8e572b8b23e29a55f5a592fe4b8cdd2651d3395daeeae5a4345"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bd0275f4b9a95301fc2d1b27d33a8bfa543a3846fd75dba5b92fe2df2c0e5702"
    sha256 cellar: :any,                 arm64_sequoia: "9bf3e5f4f87aabf8e2818f70e3132677c7e41ddf6b0f29fcadf5b0b07afbdb6e"
    sha256 cellar: :any,                 arm64_sonoma:  "9bf3e5f4f87aabf8e2818f70e3132677c7e41ddf6b0f29fcadf5b0b07afbdb6e"
    sha256 cellar: :any,                 sonoma:        "b2e40fae2366e20ad792779f3485635af1e38f2d5576bd2901bef7b33768e475"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a444c8d1dc79c4e041c50b058fa1cafe239fb5fb725b7e4483e0793b9307bd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7a7fd13248166b20b2819cba155fc261320c1bf799d5337bf14e45e9d4b63f8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

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
