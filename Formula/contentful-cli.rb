require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.5.0.tgz"
  sha256 "97e4874246d25ca0c2ced9276877fee1218e67c8ee1b45cd5342bee1cdb02316"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5f7c9fd15663db3e040f9d8d6cd19d4905a4047c6e34300e16c9760b4f78cc5f" => :big_sur
    sha256 "fa4188b83245d64ad0c8525b6fda9040111988cb19df667ec9c1e6f7f0ace740" => :catalina
    sha256 "e5d31718fa7516eac098e937f3c7333538dac84112bcbb63f06efafc19b0bd14" => :mojave
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
