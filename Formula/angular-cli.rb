require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.3.4.tgz"
  sha256 "1a2ade7d09f51bb3cd85004174f846535ba5879ef7bb14def17f41070f071698"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1c73ddea63e21c95b43fd3451a8e73bc71d63e75053d241498bd6b6b92dfee4" => :mojave
    sha256 "ddb151b88f3fab25486786c86651695b4a8c9e452270e9826fadd49a08dce7bd" => :high_sierra
    sha256 "635b7e6dbd1ade70a3efe7046423c3a7fa84fa9f79629ec35ac5fecbc6d2bbc8" => :sierra
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
