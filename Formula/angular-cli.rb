require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-7.3.3.tgz"
  sha256 "08cba4d3fa1aff10450ae7d3542b5e517c8dec6f4e941448a1b4ebb92baff727"

  bottle do
    sha256 "9bd319a660fd6ca8f3facc3c5f6e098ae380b51055899f3282c21b3fe53478a5" => :mojave
    sha256 "9593ee4a39c6325e26371c787414b13e8453574d4918d87a79edab1fb029fc03" => :high_sierra
    sha256 "ec60b5d30a03d2dd8c6c8a0d7f7345637fe63fce42e83b665f6fbaa97dc433f1" => :sierra
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
