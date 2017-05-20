require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.0.4.tgz"
  sha256 "263b5031d18afbc86670ddc1dd08a05d930e407506dcc343c2178dc69f60ccb3"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5441c3ffacee66e3e5fd887560a1d7fd72d3235b15ce65679a6111b59bff7a7" => :sierra
    sha256 "5bff8051b3189226e287436ece50eb09c78115b1bd36e250e17c1a7056cb73b1" => :el_capitan
    sha256 "c19a2a4acaace55d64e7134c03796a71bd45c64b99dc575b2e409cae4865e018" => :yosemite
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
