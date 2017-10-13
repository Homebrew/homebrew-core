require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.4.7.tgz"
  sha256 "3727fbd7893f20bf076dd7dc7aad685369f40c7e67568ec88614d5eb3c7f3c49"

  bottle do
    sha256 "2d25a2f008442186325175309d792cdeb3dc0fd89b1f2d8370eadabe9f6bbcfe" => :high_sierra
    sha256 "f3bbb5d5f120234e690bed9705716cefe9e7111d1bc4cade4f275cb64fe29d30" => :sierra
    sha256 "b7ecd3dbdc6fee361cf9bc99c1544a726d82f36273d5c62094dd042bca6c157c" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "--skip-install", "angular-homebrew-test"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
