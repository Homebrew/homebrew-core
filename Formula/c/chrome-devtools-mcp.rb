class ChromeDevtoolsMcp < Formula
  desc "Chrome DevTools for coding agents"
  homepage "https://github.com/chromedevtools/chrome-devtools-mcp"
  url "https://registry.npmjs.org/chrome-devtools-mcp/-/chrome-devtools-mcp-0.6.0.tgz"
  sha256 "6a3bf7b741efc718fe2e6b75ba97b9b0d7885b957bd4bae2c2dbcb7cd1aa6ddb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "12c34323b1c61898fefeef0a95110dbfce20bc6e944150007f660121ce106cde"
    sha256 cellar: :any,                 arm64_sequoia: "893fbbd23c6bb5504b08bb6623b2ffd89584c6663f2a0856fc208f0a623fb3d6"
    sha256 cellar: :any,                 arm64_sonoma:  "893fbbd23c6bb5504b08bb6623b2ffd89584c6663f2a0856fc208f0a623fb3d6"
    sha256 cellar: :any,                 sonoma:        "dab866e9d85b119f75836cb17276d9e6f95c2951ae6532707371b4a6bba4d017"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c23372292d3f5ad3246b1c538b7b9f5a772360290a4b5c184a859f5a3f8d266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eeee5e1d7af1fbc1c5974252f1c1319df1f83f43277c2b3156e668e6bc222a49"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/chrome-devtools-mcp/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chrome-devtools-mcp --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"chrome-devtools-mcp", json, 0)
    assert_match "The CPU throttling rate representing the slowdown factor 1-20x", output
  end
end
