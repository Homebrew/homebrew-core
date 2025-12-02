class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-2.9.9.tgz"
  sha256 "ee24ee532afcf107ebea552f123cd9eed5af2e70f15f89261e1f2b9aa40e94b7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "017acbbcec7be5fd1965c7c7669a19804a6dedf9b69dca8d688d42ff6fb50c18"
    sha256 cellar: :any,                 arm64_sequoia: "a749ca5b1675d65489ef3697be25cd0bf42266479d7d6d13695b6683f1e0413b"
    sha256 cellar: :any,                 arm64_sonoma:  "a749ca5b1675d65489ef3697be25cd0bf42266479d7d6d13695b6683f1e0413b"
    sha256 cellar: :any,                 sonoma:        "4f688029145073178979279bbdcfcfc2a06f979d4d58ba62a57f4e142bc10e5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c37fbcaf743e85b9ea3b716ea00245b73b83a610505e76d52928a250b5aab22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b92ce7add97c202d1b86295e560d2cb4b773f2674c5dc5bde781b6c58fae487"
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
