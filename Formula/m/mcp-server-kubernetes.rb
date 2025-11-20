class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-2.9.7.tgz"
  sha256 "7755b41cc279f9bab9cd2d581d0e48e9cdfb454c2a94396c968ba15adbe753c7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bf4b9cf145e0643198d3f694c9b0fd7b2ba46b70edba9a358acb83f3b7358eef"
    sha256 cellar: :any,                 arm64_sequoia: "7d67c7647ad7cb0b498e61f39cc43b6fe33988682673a9735e888607e48ac8fb"
    sha256 cellar: :any,                 arm64_sonoma:  "7d67c7647ad7cb0b498e61f39cc43b6fe33988682673a9735e888607e48ac8fb"
    sha256 cellar: :any,                 sonoma:        "289d52feecadfa9052a8fe0b1e6f31b9f63cdbdaa982fbf0fe671aa96f02265c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "580ddd18ae60fe788469123cf3edff4aa8ae183d0d8aca7ba6fc8672eb1cd961"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01dd81e6503e4cabf564f06364968b53fa51d503f0a585511f8cb8e6da86d572"
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
