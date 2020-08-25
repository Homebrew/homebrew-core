require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.27.tgz"
  sha256 "a81ff005f9fe0ba7140b277e73c9b22cf9f720f56d0a47bef2204409c8e4de06"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "95a9b15e7c85ca5624ce717bfe9a43f437aaf6e1146fec905f05082d5d2797eb" => :catalina
    sha256 "75c14c0a8c426b9cf1960602dd5b04f75ec055c0586f5f362e08304df73c0dc6" => :mojave
    sha256 "ab95fde89b75baf09d05a75a19dcd7836ba19b5c53b9e9e54890c0924a4fef1c" => :high_sierra
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
