require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.5.0.tgz"
  sha256 "61ac71406c6c3c57dc5719a832bc6c7a2da0882aa52485a677ca8a2b89c6c3b1"

  bottle do
    sha256 "1ef0c054f2e239d35bb3fd073519c8594433f5b30f24db278a8be2ce15162f22" => :high_sierra
    sha256 "8cd7bdb1266a35a76e0f91f2275fac9b199086017e8b528866265c7289fbe171" => :sierra
    sha256 "ea7b9dcb734038321aa7001a08f83e4bbcd7e7e111cb93dcb67728e069c4ed1b" => :el_capitan
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
