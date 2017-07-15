require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.2.1.tgz"
  sha256 "90efa5c4b0a40651454f55ec58b8fb99a238ee27ab4c208b2e2042bc21587558"

  bottle do
    sha256 "0f902807ae26b31e605d24078cfd8866e44d74e0da68183a58a00ba2bdcf90b4" => :sierra
    sha256 "fbc23dbe47d7ae155d53e11be4e0571ddb7b24efb2a69013e49d95871a4d0fee" => :el_capitan
    sha256 "69f3c507c315b85147f261a087e67ce1202f47be08669d9cc0ab4019b9fdd1be" => :yosemite
  end

  devel do
    url "https://registry.npmjs.org/@angular/cli/-/cli-1.3.0-beta.1.tgz"
    version "1.3.0-beta.1"
    sha256 "baf6de023f387256467ab2a64834fb31634ecb16f398ebd2a192826d1c1abcd5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "--skip-install", "angular-homebrew-test"
    assert File.exist?("angular-homebrew-test/package.json"), "Project was not created"
  end
end
