require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.10.0.tgz"
  sha256 "41ba78a0c3275b438c353cdbd2a1d87d19749a3c7648a9dd5581afe046b38677"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a446eabc8ad6fd26084da35839ca312e57175ae7896c7c284133b5259fa0b8a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a446eabc8ad6fd26084da35839ca312e57175ae7896c7c284133b5259fa0b8a8"
    sha256 cellar: :any_skip_relocation, monterey:       "d6b44e8744faab87fe7e9af8809622274e643048ba2a4b6c687339950e9c0bfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6b44e8744faab87fe7e9af8809622274e643048ba2a4b6c687339950e9c0bfc"
    sha256 cellar: :any_skip_relocation, catalina:       "d6b44e8744faab87fe7e9af8809622274e643048ba2a4b6c687339950e9c0bfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a446eabc8ad6fd26084da35839ca312e57175ae7896c7c284133b5259fa0b8a8"
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
