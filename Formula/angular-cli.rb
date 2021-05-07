require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.2.12.tgz"
  sha256 "ead49c40a525bf60280c3650b0c0cdb5f86ae48e36d90994f95b998b9aa5fcba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "42744fd2f16702d242db332e02a9ea6f2aa19ea60ee74a12de0948d6089105e2"
    sha256 cellar: :any_skip_relocation, big_sur:       "7fb3afdcf7ef53b055ff2948fbbd5c6a1f1a642a295e63a01ed9e7bfbc4ad5f9"
    sha256 cellar: :any_skip_relocation, catalina:      "7fb3afdcf7ef53b055ff2948fbbd5c6a1f1a642a295e63a01ed9e7bfbc4ad5f9"
    sha256 cellar: :any_skip_relocation, mojave:        "7fb3afdcf7ef53b055ff2948fbbd5c6a1f1a642a295e63a01ed9e7bfbc4ad5f9"
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
