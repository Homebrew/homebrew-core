require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.2.6.tgz"
  sha256 "3ef8d33edf42799decda6247f1bb565b6f486e7ddcd6798bd8b3b54df9cc592c"

  bottle do
    sha256 "f66c6cc609e70b76f7a038354c59d7fbae09274cb5315974e81e6603cc908e11" => :sierra
    sha256 "7f0bfed1132112b482113338f07b237fbe7f3c0ed64419d88eaed7fe445b5e43" => :el_capitan
    sha256 "4a38ed5e7022583c6deec81eaf33cbc7e3575bc64c62d363b62de8060bd8354c" => :yosemite
  end

  devel do
    url "https://registry.npmjs.org/@angular/cli/-/cli-1.3.0-rc.3.tgz"
    sha256 "7452bb854dc9b522f132ae28ee8357a241dc78dcc8283267797bd1702039d258"
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
