require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-6.0.8.tgz"
  sha256 "0a9fe414eb3188074ffcc52c2a1380e6c26fe45711363f8c4bf0b25bf89e94c8"

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
