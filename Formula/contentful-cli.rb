require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.54.tgz"
  sha256 "8be1856783613251c90b2025b4d7bc0f5970c483ed83cbc0484f79b1647ef0b8"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "def8f2d4ee3f3c31d9e6e16c9954759665c439f16e320d44899524b2b713dac5" => :big_sur
    sha256 "990c07b78ee143cf3e30e9cc7d78290b30d6bdfc62965d1f07cacf6d0f9bb394" => :catalina
    sha256 "d188de94094628de3a948e11f82ef54523d2fc8cf3de9ce7fa74b95052993b28" => :mojave
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
