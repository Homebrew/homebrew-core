require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.6.8.tgz"
  sha256 "9a61f01a62bd70edd68b5bbbde27981e6291afde936129bd839e98f20692944a"

  bottle do
    sha256 "812a767ca9aa8db833727d9e31ea74db86fbfa572cb3244522d40c1bc680de70" => :high_sierra
    sha256 "8843574ccec890035899b97cefb30f0ebf3d17a08687182115f94762f28844f4" => :sierra
    sha256 "8c42d9f19346d36edee4ed98109cc4e563ae0a0e03690c9790aa43c39157d8b8" => :el_capitan
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
