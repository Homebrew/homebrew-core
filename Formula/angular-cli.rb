require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-6.0.3.tgz"
  sha256 "5362f4d3cd7d39bad5ed64be605c3bded22c139d92f70819d2da8aa595a053fa"

  bottle do
    sha256 "e7bf99c73c46e7f0127c2432d12dfd62ae734dc529656cd18e49105f32aef316" => :high_sierra
    sha256 "f55ee73f06eeb00f5737d06a33e8b7ae6576ae475437ee83f09e47266ebc6293" => :sierra
    sha256 "c7f5eeeeaa8aff4c5e516dc46c071077fd6e845cc441d681bb4fe13663617d8c" => :el_capitan
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
