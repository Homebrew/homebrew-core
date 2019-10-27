require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.1.3.tgz"
  sha256 "b6a036b6b3d2f02bfcdadf04274ee46acfe092793011c8e388593c0d066dd9c6"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "511ae841546a410c0191d46f1a2a4157e90b6cc5058bf4879b7f83b52ff266cf" => :catalina
    sha256 "dc152001d72d9315bf3b88573a310591928c30ab90d63e744d7eeb519cd2904a" => :mojave
    sha256 "ea03f0e38d484e8ae55ca919e42d0455ab83af67cfc969e59d6ab5b488e68f95" => :high_sierra
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
