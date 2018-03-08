require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.7.3.tgz"
  sha256 "c6e633887a83f35a1daedb9611c367c5e108358646116f4b4827958ae67f4017"

  bottle do
    sha256 "dda767a5bee5a458bfc6468f9ba67ada664d3aa39054c03de913707b240c8b7c" => :high_sierra
    sha256 "1d4a703eb24c5f8cb9e815fc89e63cbdb10debf6c27d74ef9edba4633a45707f" => :sierra
    sha256 "abc92340a5e15b485c0a6eb01ad2b0da767f4546d3557b679e6cd5c5fd194147" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "--skip-install", "angular-homebrew-test"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
