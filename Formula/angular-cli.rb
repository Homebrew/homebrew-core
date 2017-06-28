require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.1.3.tgz"
  sha256 "7b3f4738ed6b79422aca98acfd7fb2be6db3ec385eaddf7dbd9fd6bd05db1519"

  bottle do
    cellar :any_skip_relocation
    sha256 "ebaacd7760cc7ebec4b0057473b8d880f2c6a046e0c194330a85dfc5e71c5727" => :sierra
    sha256 "9789972a22750df643b61cceefb490c0daa926bcb5c5f0d4cd11e8303a4879aa" => :el_capitan
    sha256 "67c8a0852f7c694dff9463a3da98df35ef3c115194ee61e93a4f77f2030b772c" => :yosemite
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
