class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-2.9.3.tgz"
  sha256 "770d9b646998e3fa8ec86396001583f14d06747c95e1a7fca3cbf8a287d59343"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "02afa56c5c643ecc05dda1fe7cfc45c5f4e3184181d87807d8fb9faf2fe6afe8"
    sha256 cellar: :any,                 arm64_sequoia: "dc128f0f1dfb2e6e7afe43da7daf4919a0c19b9818c1f60d9bc3bda1d4da15b1"
    sha256 cellar: :any,                 arm64_sonoma:  "dc128f0f1dfb2e6e7afe43da7daf4919a0c19b9818c1f60d9bc3bda1d4da15b1"
    sha256 cellar: :any,                 sonoma:        "d7d4d881a45205e35750bd690ebefee93d98e3b655760df5bbf5c1d2f48558ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63eb453703df9fb128ab6f401d81aee59c869f100d369c85771341378def9f3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3537311ca4087d2dd03d45db98816f667cddf2328867038de7432bb4aa01f3ed"
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
