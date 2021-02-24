require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.2.1.tgz"
  sha256 "6745fa1661497dff03222796846a75d4acc7837cc564e7c864c1e70406a6af9f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b12f987e23e910b3ac15213a3fdbe70fca1d59b7e5b66748914c25ed3f466238"
    sha256 cellar: :any_skip_relocation, big_sur:       "62f51caf778c54151c37dcbd38ecb2982658f7dd896ebee2056d7baceb25bd96"
    sha256 cellar: :any_skip_relocation, catalina:      "83d8f276a80f16c0bf4ba9e580e62ef709ae6450c0d4bcf2f88d0ea402976a06"
    sha256 cellar: :any_skip_relocation, mojave:        "1c614a3dbd78b97e86bad1992ed01bfea71301fe047f3b76ff8a0aa6f8b91e45"
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
