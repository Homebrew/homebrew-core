require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-14.2.7.tgz"
  sha256 "5536b8216bf8cf7bdf40ca26025ca0866640fec826c4b3d869a198a08d1aa4f7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f9dec3f51918fd96fd163d4e334382f89d78c538fabab8a3983a4a0fd47aae7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f9dec3f51918fd96fd163d4e334382f89d78c538fabab8a3983a4a0fd47aae7"
    sha256 cellar: :any_skip_relocation, monterey:       "88cd1d370fc09f72699cf352438793d8669e00c3a46ec596e662b1fa8ee27310"
    sha256 cellar: :any_skip_relocation, big_sur:        "88cd1d370fc09f72699cf352438793d8669e00c3a46ec596e662b1fa8ee27310"
    sha256 cellar: :any_skip_relocation, catalina:       "88cd1d370fc09f72699cf352438793d8669e00c3a46ec596e662b1fa8ee27310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c39a145222e7e327adfa71f486187b9cb427cb5211eb5272059a16d10231b3c7"
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
