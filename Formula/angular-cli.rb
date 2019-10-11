require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.3.9.tgz"
  sha256 "cd0f7dbe537e76b0f7164a927684bc20c3c446d63dbc731ec68e79bcec553922"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d2ee74093812e2b0f6c6b6712848b03b544c3e522608cc2af41d8f0fdeb4713" => :catalina
    sha256 "f16a42cf2373b39e033fcdf4ad4c83c6c81978d1ecfdb9cd79020ddea126d49b" => :mojave
    sha256 "44a7f70059f44f5bdcbc08edf41b3a6814790203a81757d9278ed7755557d019" => :high_sierra
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
