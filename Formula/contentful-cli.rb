require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.2.12.tgz"
  sha256 "dfab6842da164e4745e40fc197db5246c5012ffaf675ccc74ffb6cafcad3b964"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "371fc813be2c90f90a7715c7cdab7cee2beb42e7367cb30fb6dd1774d0956e3e" => :catalina
    sha256 "9924c90ebf9e3220807eb9f79a25ac9830c150f8b887d9dfb028d899b375d5ba" => :mojave
    sha256 "383dbda8aeb0eb66fb325ad2d3ad4a4f369a58e9dcf9bcf3f73e6e90b66e9eab" => :high_sierra
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
