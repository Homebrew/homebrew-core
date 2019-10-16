require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.3.10.tgz"
  sha256 "412f6c70142f0ef00511bce96118e882ca07de3aad034678176009f561170563"

  bottle do
    cellar :any_skip_relocation
    sha256 "82168d8f8252bf2e9c1e5dc6269707b93595f4b287de896113ebc8ad577ebf9b" => :catalina
    sha256 "67d1736d14a0fcf54fa4fdd62e8a247aecd48888f15e635ceb4f4a8f00b03224" => :mojave
    sha256 "8508a62afa6e097d0af7524d155c42b87f953cf1f6fb79bdf4ccfffab0e18c43" => :high_sierra
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
