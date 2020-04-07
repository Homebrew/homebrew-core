require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.8.tgz"
  sha256 "05093e07f9dc3ddbd104b3c88eee9618fc1ba5885bc739940a9c989a7a73d45a"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3397b3744cd25aa7cff5dcbcf8aa38185dd1c338fc7fb417ba680bff4f81362" => :catalina
    sha256 "3bb445b75d79358af60dfde8dcb96586c688deeeb586c07088575a45ed10a89c" => :mojave
    sha256 "3eb1b3c09ee4f1c41681aec6911ca7d881076de1bef7a360ee72ddc9eec61e88" => :high_sierra
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
