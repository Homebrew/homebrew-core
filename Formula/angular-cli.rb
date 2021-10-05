require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.2.8.tgz"
  sha256 "e45766dc131ed5c645e60b50921031a16169e2e0a505f63a91cb4ad3dbafe882"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4fb84ba2ced7941ae48ca7e357f18b7d6132feb9716d3d7162fcb20957b7f376"
    sha256 cellar: :any_skip_relocation, big_sur:       "245c684f885cfce724ce6c8d8f66c99ab82c649ba16fa030c15bfd88ec6230c1"
    sha256 cellar: :any_skip_relocation, catalina:      "245c684f885cfce724ce6c8d8f66c99ab82c649ba16fa030c15bfd88ec6230c1"
    sha256 cellar: :any_skip_relocation, mojave:        "245c684f885cfce724ce6c8d8f66c99ab82c649ba16fa030c15bfd88ec6230c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fb84ba2ced7941ae48ca7e357f18b7d6132feb9716d3d7162fcb20957b7f376"
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
