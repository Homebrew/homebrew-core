require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-6.0.7.tgz"
  sha256 "04f199d33e40f1d6df9a9b8c989ffa54ab8c4d19dcbff7efc135bcf1dba7038c"

  bottle do
    sha256 "3055d825b3b31ee48417a08ec76e377826db4292e71b7b680b63b01e3ff1cba5" => :high_sierra
    sha256 "895e3fae98823f50656957278f6e1e9efa08cbe699107062c41e584e322d31c2" => :sierra
    sha256 "2ddbcc281b59e5a3b199b7632c6fb87e108b98862911358cb4ed2c49be81f4e6" => :el_capitan
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
