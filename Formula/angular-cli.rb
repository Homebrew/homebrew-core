require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.1.2.tgz"
  sha256 "370b6e17dd24d33460248236a5de64f24dbeb0da07220ead731af20b3b01ea3e"

  bottle do
    cellar :any_skip_relocation
    sha256 "37060259a73d425f05fd8161b2f38ef626d68613d116f5dda431b4ac23e99bb4" => :mojave
    sha256 "2c56f1710c06120ffa89df6a584a3d7d6503185467bfae28a41748ad4533f63c" => :high_sierra
    sha256 "9c8c1149cbc76d09b830f5d12926fd477e03df0665979dacec385d93e347b638" => :sierra
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
