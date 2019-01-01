require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-7.1.4.tgz"
  sha256 "5ee2a304349236c567069810e030454298d2f3c5d2dd18f5bd91c149d2c16c43"

  bottle do
    sha256 "76eac3dac06a6e78e26d13c4c06d9d7395f7ffe4917bf0184fc4eefb98edad4c" => :mojave
    sha256 "7479d505a262985b151ac8568293b06a908fe3286bc724d30d32856d8b5a6201" => :high_sierra
    sha256 "eb740bf7b8090a5caa99357c48bb33cda73d842e889b0ff7724452ecb6c64bb5" => :sierra
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
