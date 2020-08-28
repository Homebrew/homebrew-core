require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-10.0.8.tgz"
  sha256 "9a5f6b22826098b9455b649a461bb6c5ff9e20492e435d130a77b728751a4fd4"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bbca782fe2c245bcd7d0a179c8a77545c0f2ee58279887c4a097374da28bd17d" => :catalina
    sha256 "231e10fe9c116af0561e645906697f75aca73c04446766022d7049c6516fbfde" => :mojave
    sha256 "cd382724764c1ef259d7d9b37c9106a8c9455ff6b1d4f52bf09e10dc827cb56e" => :high_sierra
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
