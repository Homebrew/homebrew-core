require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-6.1.4.tgz"
  sha256 "3d07424c9513123fcefa7fc8dd3b1af3eec25093182216ebec490393d5cf7f37"

  bottle do
    sha256 "d68fb380c08a38b39bf43a0be359be09dfd867b092023de844f35c66cb63a56a" => :mojave
    sha256 "26e5960a353baf7c2610ed0036152dbd3418ece499e7917306135e54b03b81d6" => :high_sierra
    sha256 "c4f224cd2836e30eca1206b87d814f16e08c3e7d1dd5d84932de913ec40a67b6" => :sierra
    sha256 "fd873e86ba3449045b5fb208d53b6751ae2c42c095363a9230fb12699adf39b1" => :el_capitan
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
