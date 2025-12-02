class PlaywrightMcp < Formula
  desc "MCP server for Playwright"
  homepage "https://github.com/microsoft/playwright-mcp"
  url "https://registry.npmjs.org/@playwright/mcp/-/mcp-0.0.49.tgz"
  sha256 "2bc7be6e7b8750e46e2de0f1d6b0ebd1ce2ee7874e0b9eb3b8007f4f07b525c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "378db284e86d7faa221bcd797771b8e9b766324bfae32b8a97d7a7e16410dceb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d26003f906286288293c62452b77f06f6b83a5ed2cbba2f00023c146bdc6b7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d26003f906286288293c62452b77f06f6b83a5ed2cbba2f00023c146bdc6b7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c35b2284d492fbb9587da3d934cef25d88ca7a4484d6fbd7a32219cafcd3e6f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d2cbbe82f9d8ac22b8a1473cf1e5a75861d3bc7374f03aef86807fc9a8af3b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d2cbbe82f9d8ac22b8a1473cf1e5a75861d3bc7374f03aef86807fc9a8af3b1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/@playwright/mcp/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-server-playwright --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"#{version}"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}
    JSON

    assert_match "browser_close", pipe_output(bin/"mcp-server-playwright", json, 0)
  end
end
