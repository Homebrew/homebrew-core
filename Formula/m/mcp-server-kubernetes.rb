class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-3.9.3.tgz"
  sha256 "473d551fca0d1f6c6d24a640fad5c5d1ced0af70389f667e61440c1444b3c297"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "90280a152d19a286798e9fe2ccea46e50cfe661a60e0ff78618a1540a8b076fc"
    sha256 cellar: :any, arm64_sequoia: "b9d14b7340ae9db28ef3bb634b7f44be82faa582f3150003bbce87397fb75a38"
    sha256 cellar: :any, arm64_sonoma:  "b9d14b7340ae9db28ef3bb634b7f44be82faa582f3150003bbce87397fb75a38"
    sha256 cellar: :any, sonoma:        "832e7e548d1ce5d9ce99381e5a5e7940fa9b7f801759e42c2c4507d191f9139d"
    sha256 cellar: :any, arm64_linux:   "7f9ffd7e159fe314cc1d543a81d84244138b35b435abfb0072dd0bbb07226fd9"
    sha256 cellar: :any, x86_64_linux:  "31b99dbf5dfcdd10fce088b81ec3c7fd5ab983f6f3b30395c8e80cb86c65e64e"
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
