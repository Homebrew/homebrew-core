require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.22.tgz"
  sha256 "9591f6aef3f997fff6c65ad99500765c4886cc7bd5b5a85f7ad817ef3a427d2b"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e3c0f5d07154ede5ac18c3e3edf355a53df29d94cc453fc27caa719254b407d" => :catalina
    sha256 "3dbab387bb486599fcf2ee9c52027122c58dce1a4a4032d05c576f928ecd4733" => :mojave
    sha256 "8f72eca8462285efb739179f65e709644c9c019360bc704db8652767f51db6fe" => :high_sierra
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
    assert_match "Or provide a managementToken via --management-Token argument", output
  end
end
