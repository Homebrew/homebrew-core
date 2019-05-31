require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.0.1.tgz"
  sha256 "3d1ab4accc613eef793000c83d84d2194ebffa051e80e328337dfaf74bf217f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8dac8639b96704eb1f74ce144f1a2c5990c474ad8d36ce6647371f6e4b2f144" => :mojave
    sha256 "08d604604186122ff9728828b54e0a6660735fefc345259027c47f2e6d36f646" => :high_sierra
    sha256 "bac703d9085bbf6a346e5b5bf921f414bd28d65f9d1460a0436b797671167140" => :sierra
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
