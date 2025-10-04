class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-2.9.6.tgz"
  sha256 "1cf794dd0f05667ad1a55e5bbb18d76462644b6aef883c0455c27346cdaea4d1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c41fe1ba42d63f5db565b5fffc2ee46302889b6ac5f54476c3b98fe36e9abde"
    sha256 cellar: :any,                 arm64_sequoia: "35cff739cbc32789f88e0c16e1a770b4190c4733d50a64a118fe89a5d5bd4f7f"
    sha256 cellar: :any,                 arm64_sonoma:  "35cff739cbc32789f88e0c16e1a770b4190c4733d50a64a118fe89a5d5bd4f7f"
    sha256 cellar: :any,                 sonoma:        "301229965413d231352c68769baaa409a630411a8b0807012474c4ca7d4b2f4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eec9a15cea623d8dd4a237978ef7322b34914da74278ee08157879980f503dee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4073349dbde1923818b78bfb53a382b63ec491131ad2053e003d3a66e0d410f0"
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
