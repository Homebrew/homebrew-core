require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.0.3.tgz"
  sha256 "4567d5b7a88f57bb0b2deb40045dd45587c470e688a59c04a360cc1227818401"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f20cb296199c1d8046f7ffec8f3dea3a71a5dea0c6dfb374bb04e29ed7a4d6e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f20cb296199c1d8046f7ffec8f3dea3a71a5dea0c6dfb374bb04e29ed7a4d6e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f20cb296199c1d8046f7ffec8f3dea3a71a5dea0c6dfb374bb04e29ed7a4d6e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "d587b5978bb3b7576304edf14e7badd764572d04ea66789714fa999c745bb31f"
    sha256 cellar: :any_skip_relocation, ventura:        "d587b5978bb3b7576304edf14e7badd764572d04ea66789714fa999c745bb31f"
    sha256 cellar: :any_skip_relocation, monterey:       "d587b5978bb3b7576304edf14e7badd764572d04ea66789714fa999c745bb31f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f158acf393670446e60156a32be19a0b07d9834584a8152df8d53020cbca5ad"
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
