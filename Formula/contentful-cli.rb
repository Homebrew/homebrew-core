require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.17.tgz"
  sha256 "d1a38c3f4ce6d5c5eecc02c22ec60c3de0e3f122d9a1cc1ccc070c2cedbf9e2b"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee999dffb7af4fad17a347edf0fc62f9a656ae50f47c696da3f0f5a55bddd65c" => :catalina
    sha256 "ab4a672a796b111fdbb118c51a9fa9503f31bd9d34309ca29d7a223dc508011d" => :mojave
    sha256 "104bb38a1761914b3c4648fc8e65d97fccda587bcb2b646aa383a7684f2d0f2d" => :high_sierra
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
