require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.28.tgz"
  sha256 "802c6f9e05cc577faca45de52b91523827cb393c37989ac0b8fead1d2aeb7475"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3f521379ae5cf455a0163dac22be25ff85f2f37d3b62bf8ed08560d994cb4658" => :catalina
    sha256 "ef0c62d1517ddbfe062949327e63a7b8b327d0f09c27e256e1ec53f173270d22" => :mojave
    sha256 "d038774606eb4a17c6f4554e937ced29e591ee6f7f9ff08840ba823a9bcbe012" => :high_sierra
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
