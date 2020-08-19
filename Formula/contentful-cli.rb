require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.25.tgz"
  sha256 "88d88846aab8dfd79b911516970a69ad1dab0e72507462d8a160fdd627e77279"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "11920ce87024dfb32612c25837d88964c9771560488b9e5484ed42e3cd711e3e" => :catalina
    sha256 "5a2d1fc2c259c16b7880b4b9eec8fe574424d1373ca79a3ed5887bdf65d579d2" => :mojave
    sha256 "18aff0c6b3cc55ff69691770542a625b63fb2c810d7a6e1d5d64ca5b36873c6e" => :high_sierra
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
