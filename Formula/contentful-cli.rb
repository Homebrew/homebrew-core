require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.1.2.tgz"
  sha256 "d4f0396a2c26348ce3a053a231e318f7c919c4ff6c90f5a2c8138bb1a0cbd5ba"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "43cff6d6db1614cde14a33cd48acf970dc6cc06017d463cccf6c603b4a3c0a6c" => :catalina
    sha256 "8dd842737be35bedb314f7494bb034b8b63566487d61c16679f34ff0fe7d1415" => :mojave
    sha256 "369002b4333006f6f462408d655950175548e6299642ee40f2e8ab34afb0e18b" => :high_sierra
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
