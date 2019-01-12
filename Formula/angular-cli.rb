require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-7.2.1.tgz"
  sha256 "9edc133b7e6d509c8b1c11c255ad7c907604f995b78e848e81a0d3236f9d58a8"

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
