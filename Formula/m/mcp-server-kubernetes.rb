class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-3.5.1.tgz"
  sha256 "f48dda023518f6b6c0ad65bf21db4fea1cf5ec8da6af2ae8b7cac9ce4cff14b7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "33ea753d6377d5039b110148d6c88f405e348182c2210125460b73a74bc48854"
    sha256 cellar: :any,                 arm64_sequoia: "16ac05dc7379df14d4442fc1db7676f40cdd58d4d082e448287a763eeef210e5"
    sha256 cellar: :any,                 arm64_sonoma:  "16ac05dc7379df14d4442fc1db7676f40cdd58d4d082e448287a763eeef210e5"
    sha256 cellar: :any,                 sonoma:        "a83291606189d43bf0df9d260a52ede1d36449438b18e40dfdd8395a6f4c6c09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f08ac25ef40be1a80cabfc43bc7d27bcca2f6378c622a1faf322b1fe9c69b88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a28e101bba21891626ca9cb88ce44134fd323ad978b95778e8d66e032fbf55a6"
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
