class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-4.2.2.tgz"
  sha256 "8032168a480e98b6debf31aa35626a0863514c2172deb8f9a45c66da35e87f3f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c6a82f63ca6e043fca3f60a624f82cb182b0554d446c356bebd63cbd5fff3aca"
    sha256 cellar: :any, arm64_tahoe:       "c6a82f63ca6e043fca3f60a624f82cb182b0554d446c356bebd63cbd5fff3aca"
    sha256 cellar: :any, arm64_sequoia:     "c6a82f63ca6e043fca3f60a624f82cb182b0554d446c356bebd63cbd5fff3aca"
    sha256 cellar: :any, arm64_linux:       "89e9424893d5d142b7b795dce9c49f48721be7cc84d1d0b148929e7603c1cd43"
    sha256 cellar: :any, x86_64_linux:      "a7a55d18ef1ee35a52b16ed0008925fcd8a015695f2c902bb031a939c2b210a9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/mcp-server-kubernetes/node_modules"
    node_modules.glob("{bare-buffer,bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
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
