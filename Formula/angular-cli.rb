require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-7.3.1.tgz"
  sha256 "e92e81c124de14990c714c171ab91e2dd3d35824ca642ebc1cb0601da49a738f"

  bottle do
    sha256 "3d4393c73bcc17745b77c3d708d8124cab814694136c02ac4b9987724e5cf443" => :mojave
    sha256 "e21eba2b1336f3d9856bb17bed8bf430c58840022e48756e2df9ef8d1e9343e9" => :high_sierra
    sha256 "acbf74184e3225e277b169e19a13bd6fd8671c1f7dc3138b56a2985b0e8fcba1" => :sierra
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
