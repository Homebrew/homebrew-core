class PlaywrightMcp < Formula
  desc "MCP server for Playwright"
  homepage "https://github.com/microsoft/playwright-mcp"
  url "https://registry.npmjs.org/@playwright/mcp/-/mcp-0.0.55.tgz"
  sha256 "34887296012ad1c0059a719d2ac40c5f671e7af75940254668536f1752840290"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c89fe1198aac0f8b052d150f3e739f9669000ebe565e4567fcf4c08dea3b600"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26b514338341584438c5eee6f51bf7c13a12722b7708da5118cc62c9f3e02c39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26b514338341584438c5eee6f51bf7c13a12722b7708da5118cc62c9f3e02c39"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e3967d889954f311a8b7631e1989e6df609ee24be7534622f89985521d9dfb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd5c1832e4943bf304252b002382073325b6ce0c8fa8e6076ac33887dfcf943e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd5c1832e4943bf304252b002382073325b6ce0c8fa8e6076ac33887dfcf943e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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
