require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.1.2.tgz"
  sha256 "a1cd06426e961bc4c4980f6ddfdfd81dbf1cb34f329b0234d432db27a6050bd6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "86f7b99a8799e8a0ff384074418409f83a674989c84d8ca220f9db00a45ca314"
    sha256 cellar: :any_skip_relocation, big_sur:       "e680bf4fb93924b180d3fc27b047e43f739b382dcc019c9b9b100d55e8396fa4"
    sha256 cellar: :any_skip_relocation, catalina:      "e680bf4fb93924b180d3fc27b047e43f739b382dcc019c9b9b100d55e8396fa4"
    sha256 cellar: :any_skip_relocation, mojave:        "e680bf4fb93924b180d3fc27b047e43f739b382dcc019c9b9b100d55e8396fa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce2daf2f987c9a9a939bee8df287446a8ce0759f570d39379192ce8bdc80d5b5"
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
