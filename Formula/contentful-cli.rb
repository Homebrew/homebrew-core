require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.6.40.tgz"
  sha256 "c5db9c84e96f8c04cac8996069d8b2e4f4295dabd455b48e878f7541b195eae3"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "37a8e0c08fc75cdca3a9a306f28ad9901169fe80f7d9b2761566d207eb8aa86e"
    sha256 cellar: :any_skip_relocation, big_sur:       "53dab7f8d91ebd96f70c6d4ed7d7e0576abb48edeb2a3b85e13c7ac00f5062d8"
    sha256 cellar: :any_skip_relocation, catalina:      "53dab7f8d91ebd96f70c6d4ed7d7e0576abb48edeb2a3b85e13c7ac00f5062d8"
    sha256 cellar: :any_skip_relocation, mojave:        "53dab7f8d91ebd96f70c6d4ed7d7e0576abb48edeb2a3b85e13c7ac00f5062d8"
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
