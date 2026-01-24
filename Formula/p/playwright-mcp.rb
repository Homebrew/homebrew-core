class PlaywrightMcp < Formula
  desc "MCP server for Playwright"
  homepage "https://github.com/microsoft/playwright-mcp"
  url "https://registry.npmjs.org/@playwright/mcp/-/mcp-0.0.59.tgz"
  sha256 "ee9121bc989220de56d8eeedc66262527d04a81284dd2b23a768988ae23fff6d"
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
    bin.install_symlink libexec.glob("bin/*").reject { |f| f == libexec/"bin/mcp" }
    bin.install_symlink libexec/"bin/mcp" => "playwright-mcp"
    # Binary is renamed (0.0.57 -> 0.0.58) and so create a symlink to not break compatibility
    bin.install_symlink libexec/"bin/mcp" => "mcp-server-playwright"

    node_modules = libexec/"lib/node_modules/@playwright/mcp/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  def caveats
    <<~EOS
      The binary `mcp` have been renamed to `playwright-mcp` which is way too generic.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/playwright-mcp --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"#{version}"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}
    JSON

    assert_match "browser_close", pipe_output(bin/"playwright-mcp", json, 0)
  end
end
