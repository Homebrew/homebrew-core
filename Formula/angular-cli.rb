require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-6.2.3.tgz"
  sha256 "395b87da466d6018620d1dfd2fc962432d64771c55d1a11da28a55fe42d54ba2"

  bottle do
    sha256 "5ea21196430f75cbbf1e3810fbb45d8d6ed8252d4aecbdc9035835a597f43e9d" => :mojave
    sha256 "9463ea072af8954f7b4b2289770f0d17ce33369c354e69704d8ee1cf2e3638ec" => :high_sierra
    sha256 "4ce7d82c8cd24d3e75d5fd6e8175cbc7f766fed5355e6fd7cac7fc0e43fdad4f" => :sierra
    sha256 "36a7273dc84ee2d8b919e5dc5ad6166d3338fc9bb40644613e85dd70811cadbe" => :el_capitan
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
