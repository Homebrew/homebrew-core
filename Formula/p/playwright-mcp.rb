class PlaywrightMcp < Formula
  desc "MCP server for Playwright"
  homepage "https://github.com/microsoft/playwright-mcp"
  url "https://registry.npmjs.org/@playwright/mcp/-/mcp-0.0.56.tgz"
  sha256 "bed694ab65e1d8f28fc9397f38eb873a79f33d0f673eba89e0f8efcda7a52967"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "687f55608fa971416d4e980c1dc7b58bc166f99f1c5f92ca468f40cc176ef280"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f507bdac5169fc8081f7d6e4469518d86d544673db2d12d78b2876a11061cb24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f507bdac5169fc8081f7d6e4469518d86d544673db2d12d78b2876a11061cb24"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcfead9b8f622041e9b52f13820a37ee648c381bdc8c33d3c0a673556be609c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c0a2b9e9a1f0fbadd202a72ae4d354dcc3a24809da201512249d9cb8186560f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c0a2b9e9a1f0fbadd202a72ae4d354dcc3a24809da201512249d9cb8186560f"
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
