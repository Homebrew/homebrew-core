class ChromeDevtoolsMcp < Formula
  desc "Chrome DevTools for coding agents"
  homepage "https://github.com/chromedevtools/chrome-devtools-mcp"
  url "https://registry.npmjs.org/chrome-devtools-mcp/-/chrome-devtools-mcp-0.10.2.tgz"
  sha256 "6a65a02c4883455f00801c8e5dc6e04d6d971f49b020cb5307c2a1ff8c729bd5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b0053169dc64b0bb6c540f9daa8f326152af92000766365b44d72b92efb98b81"
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
    assert_match "Represents the CPU slowdown factor.", output
  end
end
