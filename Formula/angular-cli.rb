require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.0.5.tgz"
  sha256 "70940a48f2a484cebe44b1b68451ee442d1424188905abba159d7b58a14f4427"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9429e62fe32e0912a64263ca558c006ed81946546a35073f52d53290fd7d3459"
    sha256 cellar: :any_skip_relocation, big_sur:       "85050512e8a4055542200dba9b04720059f0e20e57163b8e75ecd71ab3dc8c8b"
    sha256 cellar: :any_skip_relocation, catalina:      "85050512e8a4055542200dba9b04720059f0e20e57163b8e75ecd71ab3dc8c8b"
    sha256 cellar: :any_skip_relocation, mojave:        "85050512e8a4055542200dba9b04720059f0e20e57163b8e75ecd71ab3dc8c8b"
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
