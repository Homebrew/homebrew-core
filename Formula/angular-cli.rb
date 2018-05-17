require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-6.0.3.tgz"
  sha256 "5362f4d3cd7d39bad5ed64be605c3bded22c139d92f70819d2da8aa595a053fa"

  bottle do
    sha256 "27045e9261638bfd747fcd795053d0e31380a831914e4d17395fd7fedb909c1f" => :high_sierra
    sha256 "ff19f3867e83e38f4bfb39aeb617f11d1ac49901942a6dfd65e65ccd2ad6915e" => :sierra
    sha256 "b8be10a513fbfd607794e42f6940931024a3228452eeaa75e646b12af6169146" => :el_capitan
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
