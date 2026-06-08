class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-3.8.0.tgz"
  sha256 "9341cbe41747e55edbfed4bb178541c80fa96fc77f9090c211cee77c7b21d135"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0fbdf9132544cedd88d980b8e831d77f68b7acdf1c3fe0fcb5460994653eaeb8"
    sha256 cellar: :any,                 arm64_sequoia: "e802d33256bb82ba03541c751cb5ad36a6c3ee7cb420fca58059dc5dc4055365"
    sha256 cellar: :any,                 arm64_sonoma:  "e802d33256bb82ba03541c751cb5ad36a6c3ee7cb420fca58059dc5dc4055365"
    sha256 cellar: :any,                 sonoma:        "4634da1cd74cc7729b5a065ab25b7372cdb0ce6fdb5653cc303b84d8d381b558"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a89c67f6aef828a7bc8552ffd39ba933035ad1c2206a3cb93bebf0611ee1ea84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac85a970757e30cdc49e647b66a9987179c8b339f07f0e0762c37d01757a4b3c"
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
