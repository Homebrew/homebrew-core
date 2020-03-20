require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-9.0.7.tgz"
  sha256 "6a76a48d29c48c9431e37eaa9499b960323adc27a31572d8535cdb832047a6c1"

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
