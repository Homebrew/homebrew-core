require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.2.3.tgz"
  sha256 "178de352a3a546bdf88cff345844cf6ab928789c57061ee0a5ef508b7e73ee22"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "445cab301158ac9a58312acf3f45f0804126918f237cceb1cb8bfc86f9d3db9d"
    sha256 cellar: :any_skip_relocation, big_sur:       "a9f13a2b4dc98204ce0537235b8836103360736d49484da974f7af3c76b0f082"
    sha256 cellar: :any_skip_relocation, catalina:      "6a0d1b89460ae9a4daf921d54d7754dd70622374a9dfc8bd65c1b38b732acd50"
    sha256 cellar: :any_skip_relocation, mojave:        "c72b3bba7bbe590d398ee74b34b8d8920538b9a5de2b0e4b5185faf6cabdaab0"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
