class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-3.2.0.tgz"
  sha256 "c8bf8254bab03b0715a0e8ab26aa94a52b04f49f20afe905f46e6de007c1c1cc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b6d71409dcf2cde018670c290b1842c2889e7e901927a661ce5f3422c3a70260"
    sha256 cellar: :any,                 arm64_sequoia: "996705fa8e0e5d260cd19f35c0431eb2488a52a478b45e38700cd118a74966cf"
    sha256 cellar: :any,                 arm64_sonoma:  "996705fa8e0e5d260cd19f35c0431eb2488a52a478b45e38700cd118a74966cf"
    sha256 cellar: :any,                 sonoma:        "311dce8a705b6b559e58e06b89616dfe8b03d59193bcd27003fed4becad83027"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b1640a036e056b6621ba480ddbfc7892bafc859f3c2f57338cd34551ccbbfce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e94b9e348dddb6249939a68201aa9e6520e00266d0fe6f269721ca061eadb12e"
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
