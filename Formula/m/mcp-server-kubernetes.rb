class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-4.2.2.tgz"
  sha256 "8032168a480e98b6debf31aa35626a0863514c2172deb8f9a45c66da35e87f3f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ec3a1caef84b1d9165355a8d1a58c888a9d99ad1e1b2e39a159ae5cf5064da92"
    sha256 cellar: :any, arm64_tahoe:       "ec3a1caef84b1d9165355a8d1a58c888a9d99ad1e1b2e39a159ae5cf5064da92"
    sha256 cellar: :any, arm64_sequoia:     "ec3a1caef84b1d9165355a8d1a58c888a9d99ad1e1b2e39a159ae5cf5064da92"
    sha256 cellar: :any, arm64_linux:       "2cc10385ff95d60a8296af1d12d131857ce82b765c6f98409ac06de4fff389fb"
    sha256 cellar: :any, x86_64_linux:      "9c83bd0e57b36588a32ed5e7a915451dcdbf18cd896f013947302f0f51fc07d5"
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
