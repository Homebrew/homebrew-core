require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.1.2.tgz"
  sha256 "3a35795763bbbf0b48a500666ab2d86cd4440098a043527f98e242cd222518d2"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbe81fb9bc57dc9eb0222299d5f0da71fc8fcf62ccf16c5dd45dbdc99d294f56" => :sierra
    sha256 "9d3b719007bf009fc7806fdf5113308f68f8a01e87d3f63f6924593955d30c6a" => :el_capitan
    sha256 "5fc1c9049be1e379c9d9255b071b3fc7bfd4291b678cf34cd9cc5f9c1e0ca8e8" => :yosemite
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
