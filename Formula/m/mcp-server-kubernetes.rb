class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-4.2.3.tgz"
  sha256 "6c483fd6482ebdb2099ce43be6a5390621988f46fc4899a3ba1edf0c46410c65"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "70b58d606616c637b4402cdb017a48a136514ea03907373706fc9d004f1763fa"
    sha256 cellar: :any, arm64_tahoe:       "70b58d606616c637b4402cdb017a48a136514ea03907373706fc9d004f1763fa"
    sha256 cellar: :any, arm64_sequoia:     "70b58d606616c637b4402cdb017a48a136514ea03907373706fc9d004f1763fa"
    sha256 cellar: :any, arm64_linux:       "5b67a42032f6564e3a00e9c778b8b3424c5a2c02560c39344a9f5a12e59d3a9d"
    sha256 cellar: :any, x86_64_linux:      "387ceb6f7b7a389fbffc99ea9ad91b36a28ff80476f32d94424506b11243e69f"
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
