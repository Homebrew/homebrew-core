require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-14.2.9.tgz"
  sha256 "a56e2d9a070f73feee57af4f1133f0a5890d22b6acd6eb0d92ca6ca1466be998"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b325c106b26cfc130ef336e2cbb071af0e655c38b31227be9b687b2490bf8675"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b325c106b26cfc130ef336e2cbb071af0e655c38b31227be9b687b2490bf8675"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b325c106b26cfc130ef336e2cbb071af0e655c38b31227be9b687b2490bf8675"
    sha256 cellar: :any_skip_relocation, monterey:       "6c733871555e96ca1aeb4991f2a7e12902e931167ea92959ef7c437055a38a2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c733871555e96ca1aeb4991f2a7e12902e931167ea92959ef7c437055a38a2c"
    sha256 cellar: :any_skip_relocation, catalina:       "6c733871555e96ca1aeb4991f2a7e12902e931167ea92959ef7c437055a38a2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b325c106b26cfc130ef336e2cbb071af0e655c38b31227be9b687b2490bf8675"
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
