require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.28.tgz"
  sha256 "802c6f9e05cc577faca45de52b91523827cb393c37989ac0b8fead1d2aeb7475"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "95ad0e165c35fb01687769cce1ddc91dec39fd2c8070757587b5751e8de379a8" => :catalina
    sha256 "29683abd54162b59a237df02680e7f10c7cf72926f30b1fb7cc20b49312e84b6" => :mojave
    sha256 "007370edf81200b3408319ed0192662597a1880bc4ba45f5d64abb9415f68c35" => :high_sierra
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
