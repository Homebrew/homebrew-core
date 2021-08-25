require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.2.2.tgz"
  sha256 "a26b0e227d1feed131d66afa6140ec7c46a571a66453fb0ea5a01cfbfefc4e43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "911b21d1840596a4560bdce17ea87b42853a13f71f7cee12b1db95af70f7eedb"
    sha256 cellar: :any_skip_relocation, big_sur:       "c986dad8ccce14604597e3466455aa8686dd618b7347fbbdff1d09cb4263144d"
    sha256 cellar: :any_skip_relocation, catalina:      "c986dad8ccce14604597e3466455aa8686dd618b7347fbbdff1d09cb4263144d"
    sha256 cellar: :any_skip_relocation, mojave:        "c986dad8ccce14604597e3466455aa8686dd618b7347fbbdff1d09cb4263144d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "911b21d1840596a4560bdce17ea87b42853a13f71f7cee12b1db95af70f7eedb"
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
