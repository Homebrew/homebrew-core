require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.3.7.tgz"
  sha256 "b8641f8f270861023a0c37cc3f445969d27580687a1fbd8ccf822f55a48b8637"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ffa9a38a1947e001e3c9ef4d22dee6031ddd90b13d3d4019fc582e551abb44d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ffa9a38a1947e001e3c9ef4d22dee6031ddd90b13d3d4019fc582e551abb44d"
    sha256 cellar: :any_skip_relocation, monterey:       "e8ffc3c00b2dc8ca2aa1a6dcad2f85211c50801617b0fff8dfb5b417b44b62da"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8ffc3c00b2dc8ca2aa1a6dcad2f85211c50801617b0fff8dfb5b417b44b62da"
    sha256 cellar: :any_skip_relocation, catalina:       "e8ffc3c00b2dc8ca2aa1a6dcad2f85211c50801617b0fff8dfb5b417b44b62da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ffa9a38a1947e001e3c9ef4d22dee6031ddd90b13d3d4019fc582e551abb44d"
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
