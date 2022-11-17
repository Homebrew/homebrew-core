require "language/node"

class Pandemics < Formula
  desc "Converts your markdown document in a simplified framework"
  homepage "https://pandemics.gitlab.io"
  url "https://registry.npmjs.org/pandemics/-/pandemics-0.11.8.tgz"
  sha256 "946b334c97c5483a589dbb87458a392b47ae01c61803d889d3027e3de48348c8"
  license "BSD-3-Clause"

  depends_on "librsvg"
  depends_on "node"
  depends_on "pandoc"
  depends_on "pandoc-crossref"

  def install
    system "npm", "install", "--nodeps", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal version, shell_output("#{libexec}/bin/pandemics --version")
  end
end
