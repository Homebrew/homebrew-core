require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.0.1.tgz"
  sha256 "3d1ab4accc613eef793000c83d84d2194ebffa051e80e328337dfaf74bf217f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2245bf2a90bc9250406b76bcfc2031ef99bb059ab5eb1126be0442ba70e9bfb" => :mojave
    sha256 "5b91766bbdac940e0e73c9e0a4783b03ca8ce4a1f51b3e68c5d1c3af1129496f" => :high_sierra
    sha256 "c2bc545ceae949052da4a3bf19e037cc2cfcc14533af30e36ad4abfdc970118d" => :sierra
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
