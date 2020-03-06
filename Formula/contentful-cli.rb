require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.2.14.tgz"
  sha256 "58d03fc3431a6728ed246c75d0542a1a81cc4c103c26a6b1ba0bbe13f5a31eb1"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "137d2db68c49e1aa64c55968b076a2d6f42a8b99b296d25a98b6d04941527019" => :catalina
    sha256 "aeb33be5a99d9340d8b0ca94c2dc24177efbd588ee66fe7752cae1223b855542" => :mojave
    sha256 "4f35edeae028cbeca582c2dbb2b01c6eb32ed8b65ef7776fa885d9678655e6fd" => :high_sierra
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
