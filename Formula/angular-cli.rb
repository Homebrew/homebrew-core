require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-9.0.3.tgz"
  sha256 "8d7906bc2a5106b0bbd0e831688564a4bf07d3bcb3de0203cb093bd3b47a5108"

  bottle do
    cellar :any_skip_relocation
    sha256 "a758f28f9fbd82c22f1fefd7ca8717299fa4a8def5e3346b0f3293a01313bbb8" => :catalina
    sha256 "a4e27c9da632978e6b208b94f29b466d268750e0042492e679c43c4a3f7f6b7d" => :mojave
    sha256 "d22782b2a7b00c8356475a984287e5bcc0e93c7bfde307d70cac7f2aab892cbd" => :high_sierra
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
