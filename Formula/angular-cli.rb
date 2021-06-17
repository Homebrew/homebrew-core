require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.0.5.tgz"
  sha256 "70940a48f2a484cebe44b1b68451ee442d1424188905abba159d7b58a14f4427"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1539bf7df8b98d6420204bf9a9461f99e977223cc6cf60b2ccf7d6a985ffd74e"
    sha256 cellar: :any_skip_relocation, big_sur:       "d578740e3c9197de64df497c4eb3d38141dbf9ac35d63477f332c52d9c81763d"
    sha256 cellar: :any_skip_relocation, catalina:      "d578740e3c9197de64df497c4eb3d38141dbf9ac35d63477f332c52d9c81763d"
    sha256 cellar: :any_skip_relocation, mojave:        "d578740e3c9197de64df497c4eb3d38141dbf9ac35d63477f332c52d9c81763d"
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
