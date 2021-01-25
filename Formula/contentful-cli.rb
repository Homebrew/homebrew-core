require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.5.10.tgz"
  sha256 "cc1a7abb4613cdf5009887730b200b2ebf6bdcb25e2faae15520891d02a3e1f3"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1a40a28e476196f6d62218a6ac42af76b8f6907a0f2120a0b038d0617b7181cb" => :big_sur
    sha256 "5c51dfa960a60dc69f5ab37247564714bca07feb3e22a9a4d6de914fa56f6405" => :arm64_big_sur
    sha256 "c570fcf360768cb6ddcb0ba62272f6938bfe6767e132ae555e4876d5006d5e74" => :catalina
    sha256 "25674be7172d66702ec04fe4628233079530990ba606dc53e77075825725854b" => :mojave
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
