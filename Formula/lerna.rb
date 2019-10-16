require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-3.18.1.tgz"
  sha256 "7d3551670f9c849e8602fc81a24ceea7d15532c005de40c6d8cdcb08dbb1e231"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e169543fd56a7ed9033c3474c216fdb933158edb0e63426b10a3f11538da7f8" => :catalina
    sha256 "d5327c7b0a8d1349af0d4473b987eb24c4929108819094bd3f7ffe374f5e8f00" => :mojave
    sha256 "feae6995d12e1236a40f751caf573706ac2db690004f38fc336ba9d5763100a6" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
