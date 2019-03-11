require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-7.3.5.tgz"
  sha256 "7ddd13b393e2c0de66a8b7c775dd54fb28790d5ddc261ed001be9c35a0a35738"

  bottle do
    sha256 "6725640c1e1cb12b68f004258048d1c9c14ac9dab79bcf0f5328776e61803fba" => :mojave
    sha256 "014758460650cd9add6d6a90cb686c05a20632ffce5ebd9a6b9107b93533efa8" => :high_sierra
    sha256 "ded037019917fed755847883d616ed253e9090d5d5fac4e175ba7af86ac7188f" => :sierra
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
