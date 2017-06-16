require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.1.2.tgz"
  sha256 "3a35795763bbbf0b48a500666ab2d86cd4440098a043527f98e242cd222518d2"

  bottle do
    sha256 "e296575242de64ef7a1518259812a52b0fbc982f0add7e4888e3f159fbb8ceb1" => :sierra
    sha256 "c01e8e9859d86e0e941aef50bf57f16ca9f1fbb57d863e8ce4bfabeec0c5d80d" => :el_capitan
    sha256 "08736aa8f515c8b543b1e8160283f88872a731218d659e223bf620abe6198aaf" => :yosemite
  end

  devel do
    url "https://registry.npmjs.org/@angular/cli/-/cli-1.2.0-rc.0.tgz"
    version "1.2.0-rc.0"
    sha256 "848baf1fb4b3ddd6f8ff457eab5c103a9c50b7d0c05849b7d42c220f468fdf25"
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
