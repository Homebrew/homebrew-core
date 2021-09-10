require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.9.15.tgz"
  sha256 "37731e68b3fe20b2613a77833197c21559b890154ebf5f5949ea25f2f77e628d"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f2af621180f64e7a3e572c9cb187ffeb97bedd6770cff1850b360e1d9bfd6449"
    sha256 cellar: :any_skip_relocation, big_sur:       "3e15f22ea17b03f361310daff7a082b02228b6c00a815f496c5bafd9196b1af8"
    sha256 cellar: :any_skip_relocation, catalina:      "3e15f22ea17b03f361310daff7a082b02228b6c00a815f496c5bafd9196b1af8"
    sha256 cellar: :any_skip_relocation, mojave:        "3e15f22ea17b03f361310daff7a082b02228b6c00a815f496c5bafd9196b1af8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa9c1fb291a02c2f5e385b1b9306ff9020dd54a9fe0490225c50b231251668ea"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
