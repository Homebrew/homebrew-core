require "language/node"

class Pandemics < Formula
  desc "Converts your markdown document in a simplified framework"
  homepage "https://pandemics.gitlab.io"
  url "https://registry.npmjs.org/pandemics/-/pandemics-0.11.10.tgz"
  sha256 "80987cfc42576ced72e4c8edbab8419800fbf59e615792bbc710c0e2822c37f8"
  license "BSD-3-Clause"

  depends_on "librsvg"
  depends_on "node"
  depends_on "pandoc"
  depends_on "pandoc-crossref"

  def install
    ENV["PANDEMICS_DEPS"]="0"
    system "npm", "install", "--omit=optional", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal version, shell_output("#{libexec}/bin/pandemics --version")
  end
end
