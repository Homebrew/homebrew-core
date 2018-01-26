require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.6.6.tgz"
  sha256 "96477e357732ac5b29580ddc2467f919ad412af4ee63e2404ac83cba43ddec23"

  bottle do
    sha256 "bb4de69bc06f9c35b3a53d15d8c65aba425c9cb67f492d4b2ca70f10209811cf" => :high_sierra
    sha256 "0b95111e7950357d0621c959de898abb724a8d99f857661e7c4a71224196f389" => :sierra
    sha256 "97c04db1585226691bf990a0b0f0637b2085c99a3d25134cffae9dcd45b551f1" => :el_capitan
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
