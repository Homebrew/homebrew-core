require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-14.2.4.tgz"
  sha256 "609107ee9025d33358ed8f9a4e81522e2ab601d647e43505678ebeb7c9cb2694"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a28d92b1a1fc7a7c2df57e677b61a4513a7c644c68d78de92505c74d03878d17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a28d92b1a1fc7a7c2df57e677b61a4513a7c644c68d78de92505c74d03878d17"
    sha256 cellar: :any_skip_relocation, monterey:       "adb29daa32c48aca38416f04c0f6500c1eef10d1c94783d6a7a7e6947f09418e"
    sha256 cellar: :any_skip_relocation, big_sur:        "adb29daa32c48aca38416f04c0f6500c1eef10d1c94783d6a7a7e6947f09418e"
    sha256 cellar: :any_skip_relocation, catalina:       "adb29daa32c48aca38416f04c0f6500c1eef10d1c94783d6a7a7e6947f09418e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a28d92b1a1fc7a7c2df57e677b61a4513a7c644c68d78de92505c74d03878d17"
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
