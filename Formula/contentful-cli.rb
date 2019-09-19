require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.1.0.tgz"
  sha256 "44f9274baf1263cb69652f7e534b57d3de54f6ccf6700d48fdd0ea98ae1e1e44"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a448c176249fba489368a21af66eda991a25ba08690bfd867fcffaa850201cf" => :mojave
    sha256 "001d2416f2239558f82fc552512b8f03f7b078b16e14e5d183cd0cdd392f9899" => :high_sierra
    sha256 "83a09217fc93c4c393ca8f5cc0a067d35f783370112e547d89e556880224db15" => :sierra
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
