require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.7.4.tgz"
  sha256 "deb044ec8823bfee8f44f8b16ecc4807a79f7eaa5dec1d13a7b25f6cae8b2cd5"

  bottle do
    sha256 "9826b1353d40a14081f73a41def2afd4e243cbd6138648ce9d6196208443a560" => :high_sierra
    sha256 "b88490decb1a9c6ad79e877e267ecf950c105da94bb85516208cefe93657e4a1" => :sierra
    sha256 "7e072127a52356459a4dd604f9e267495f1fc118b65a9a630468f737a6d20ff0" => :el_capitan
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
