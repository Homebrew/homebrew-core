require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-14.2.3.tgz"
  sha256 "6ae61607c3f0e4836cea65d80ac7b623e1135bc93eb971cbd9892ada5e88b99b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ec46434f223d35886b13f1ec319a4b8c259c8818cb029d886061d04ef8716bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ec46434f223d35886b13f1ec319a4b8c259c8818cb029d886061d04ef8716bc"
    sha256 cellar: :any_skip_relocation, monterey:       "e205b76ab637ac316d83fd0879785627a313e71d2b745d78d7ee31b9978785bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "e205b76ab637ac316d83fd0879785627a313e71d2b745d78d7ee31b9978785bc"
    sha256 cellar: :any_skip_relocation, catalina:       "e205b76ab637ac316d83fd0879785627a313e71d2b745d78d7ee31b9978785bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ec46434f223d35886b13f1ec319a4b8c259c8818cb029d886061d04ef8716bc"
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
