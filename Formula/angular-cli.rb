require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-9.0.2.tgz"
  sha256 "ba6bd43847aaeb2be8f9abaa3bd9d5c6531e565f37108cb9d61ee477cce78b4c"

  bottle do
    cellar :any_skip_relocation
    sha256 "f585a2d7bfef91e5a95befa84adfdc909b1296ac094e18653d03820220c9fbab" => :catalina
    sha256 "1661447daf0e09bd57c72ec32cb375d0fd1011bb0e5fcdb31905f749765f72f2" => :mojave
    sha256 "d16f7f4089bc03123fe86ec3aac2712bcc2fc51e72d69d5c2c7e695bee7d1dee" => :high_sierra
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
