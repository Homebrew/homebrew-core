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
    sha256 "1827a21b902d7316c3ff4cbdf78863b2ec44c15289e469094c35a0ecf3d451b4" => :catalina
    sha256 "f6585a5de258814244af0985eae9fca5ce7c61c6927ec5b1d4beb24d1dab7a55" => :mojave
    sha256 "be024b0cfd1f54a92128e84c7d288397cca55a4f36d391c538988a3441e1c2fd" => :high_sierra
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
