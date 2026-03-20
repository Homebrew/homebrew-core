class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-3.3.0.tgz"
  sha256 "dbbd38fb8ce2beeb0e9fb497222602fbe78cf3c00dfeb056c2113e0f4879bf55"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2fe3a9a7a3f34fe4fc78b54951e480f8906663a5e56144b99215ce3483def915"
    sha256 cellar: :any,                 arm64_sequoia: "f6b1bf024ad1e730dc1d953993a3998b4e9d1d9ebc8a401bd989de2244b0e753"
    sha256 cellar: :any,                 arm64_sonoma:  "f6b1bf024ad1e730dc1d953993a3998b4e9d1d9ebc8a401bd989de2244b0e753"
    sha256 cellar: :any,                 sonoma:        "da6e3c1b740d6d4dfadb60b05d1086d68e2626d8cdb3535ef4c3ed713d836afd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4b93e0c7421c5f96845c633645aa04f6a7f4e0e099f6fad7fb47cb1c1dbef66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4767ed3dd6e19f8e2901353633b6361148d708c6cc0ffa4def14cfef9b16c22d"
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
