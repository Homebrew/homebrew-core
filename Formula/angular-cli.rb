require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-14.0.2.tgz"
  sha256 "279636f3ec4767d413fe79a220e6a88a6d1fc90d11b857b7b811c20b40e9d709"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71ad8b658a53498ee29efa7a273dbca3c2b81bcad058f05c1a0ae2c7d8d9f029"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71ad8b658a53498ee29efa7a273dbca3c2b81bcad058f05c1a0ae2c7d8d9f029"
    sha256 cellar: :any_skip_relocation, monterey:       "7baba07afc65e293adb3bb7b75f35d8b32ac25871970aef0b9199f7e452e8b22"
    sha256 cellar: :any_skip_relocation, big_sur:        "7baba07afc65e293adb3bb7b75f35d8b32ac25871970aef0b9199f7e452e8b22"
    sha256 cellar: :any_skip_relocation, catalina:       "7baba07afc65e293adb3bb7b75f35d8b32ac25871970aef0b9199f7e452e8b22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71ad8b658a53498ee29efa7a273dbca3c2b81bcad058f05c1a0ae2c7d8d9f029"
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
