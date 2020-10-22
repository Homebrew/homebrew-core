require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-10.2.0.tgz"
  sha256 "86699a38ca442f42facb627b94162a7377dad7504db06eb8c2ba0771db1f43f9"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d7eb0f2b0e2b0f2ff18fef6726676cc318fb8afe807d574aa044eeb3f4ed0810" => :catalina
    sha256 "e2bb7e3fa7ad544b9a3c9dbd64f2538c56f58fcd2a776349e990c3b3f0f697f8" => :mojave
    sha256 "da7a1b6b2b0f06c150a0faa71890a619436cdfc89a5a1a9cccf4205501eab19f" => :high_sierra
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
