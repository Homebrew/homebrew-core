class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-2.9.5.tgz"
  sha256 "109ee99a6d43392a932878790f3fe084b8940251cdf02ff2d5024860903af4f8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4d1396dac1979c1b7f0c3243b41f8654f64ff83c32d83ba9f030fe333ca9251c"
    sha256 cellar: :any,                 arm64_sequoia: "ada8bfac02c0a6f43d10b3c7a44b3d44bc2f5cea64c341bc582b38b51607211c"
    sha256 cellar: :any,                 arm64_sonoma:  "ada8bfac02c0a6f43d10b3c7a44b3d44bc2f5cea64c341bc582b38b51607211c"
    sha256 cellar: :any,                 sonoma:        "9de2335c7a7565fa98a6ef2d9e170ca3447ac0970a32e14e8208183d65eee461"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a7777a6d8355d24a8a799fba17b657266754cdc739b5b4ab8d5697d786df28f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff3868cf7bc1e5f02267c4bedec0bb180cd0646526f56cfb043e0e1b628e15e0"
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
