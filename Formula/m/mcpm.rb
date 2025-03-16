# typed: strict
# frozen_string_literal: true

require "language/node"

class Mcpm < Formula
  desc "CLI tool to scaffold and manage MCP servers"
  homepage "https://github.com/trevoruptain/mcpm"
  url "https://registry.npmjs.org/@mcpkit/mcpm/-/mcpm-0.1.0.tgz"
  sha256 "5b673230c15c7baee47cecef50dc0ae005c02e8457e4b3e0c2b1db0b6564e428"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/mcpm --version")
    assert_match "0.1.0", output
  end
end
