require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.0.5.tgz"
  sha256 "780201098da330aa2750dab986688172f24650c16403f0b3061370f6ca68b47a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "357b1e367395c6c4c1b2a216cd78c12adee9618159504c40fcdf1ba5907c4b98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "357b1e367395c6c4c1b2a216cd78c12adee9618159504c40fcdf1ba5907c4b98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "357b1e367395c6c4c1b2a216cd78c12adee9618159504c40fcdf1ba5907c4b98"
    sha256 cellar: :any_skip_relocation, ventura:        "b3fd1b68973ab91d9439090cf075c20b89ebf09acd20df39eebfa4e00756b98c"
    sha256 cellar: :any_skip_relocation, monterey:       "b3fd1b68973ab91d9439090cf075c20b89ebf09acd20df39eebfa4e00756b98c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3fd1b68973ab91d9439090cf075c20b89ebf09acd20df39eebfa4e00756b98c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "357b1e367395c6c4c1b2a216cd78c12adee9618159504c40fcdf1ba5907c4b98"
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
