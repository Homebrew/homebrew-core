require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-9.0.6.tgz"
  sha256 "a1d5ff1a5b01de10daec715b5db768b1e16178f8d4262aa7973ff3d1204d852f"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b7f0548ab9de428b87ba86bbb9d2e5cbfe0d109f31a1839720fa0f1b4f12d1e" => :catalina
    sha256 "09cf9be2a437e79007ddb2211dbd9acea9aef7632e56a3442dac1560d6e35d8f" => :mojave
    sha256 "30017bd4e2d32f4a584884dfc539c7d056aedaef4248979382e85bd4775df907" => :high_sierra
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
