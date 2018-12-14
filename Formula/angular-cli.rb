require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-7.1.3.tgz"
  sha256 "b685a610eb5bbe57ed693c441a4c47e2f7e1fb2bf04f6bfc7c98f14d17e0419b"

  bottle do
    sha256 "57b8dc193dd6710f543ec32196eace7e96371a41d681086aefed7745f9807344" => :mojave
    sha256 "eac3474b57f2bd96ad1953e60493b4a2eaf588328a77c86a89650849fe6856e9" => :high_sierra
    sha256 "3b3e9e680b897f51c68cefd66361b970048ca20e714f2cf18bf58aabd5f932ac" => :sierra
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
