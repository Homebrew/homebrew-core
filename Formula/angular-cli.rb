require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-14.2.9.tgz"
  sha256 "a56e2d9a070f73feee57af4f1133f0a5890d22b6acd6eb0d92ca6ca1466be998"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d1f8d77ad843022f1f372b9fc6bcd24b365de5675e04c6206fc03eb780becb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d1f8d77ad843022f1f372b9fc6bcd24b365de5675e04c6206fc03eb780becb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d1f8d77ad843022f1f372b9fc6bcd24b365de5675e04c6206fc03eb780becb0"
    sha256 cellar: :any_skip_relocation, ventura:        "8d21f5e2e4b75ad94669c3e728fd64f596d3aaa3c0b71cd28b2d81aae3a2f417"
    sha256 cellar: :any_skip_relocation, monterey:       "8d21f5e2e4b75ad94669c3e728fd64f596d3aaa3c0b71cd28b2d81aae3a2f417"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d21f5e2e4b75ad94669c3e728fd64f596d3aaa3c0b71cd28b2d81aae3a2f417"
    sha256 cellar: :any_skip_relocation, catalina:       "8d21f5e2e4b75ad94669c3e728fd64f596d3aaa3c0b71cd28b2d81aae3a2f417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d1f8d77ad843022f1f372b9fc6bcd24b365de5675e04c6206fc03eb780becb0"
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
