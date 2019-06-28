require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.0.6.tgz"
  sha256 "465f36d5cf3dac122e7e7c74ce4a402fa9b5f3b38849a231d005e6b27a3aa6c7"

  bottle do
    cellar :any_skip_relocation
    sha256 "2dd8ab090998d65d177f77f3d12b87b18656459d98c00127d069b100465827b2" => :mojave
    sha256 "7bf437fac61cc5ae059b186fffc8c4d056353829fd0d12b6d19f3eb8633bc923" => :high_sierra
    sha256 "b031d077ce7c21026aef8e87d9b5d19b665dad327862e7dfa59f8fcacb4a2c5b" => :sierra
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
