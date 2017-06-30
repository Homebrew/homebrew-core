require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.2.0.tgz"
  sha256 "e03e7f023a1c7eeebd45058e3b698708fe36ce703d706489222083af8681edde"

  bottle do
    cellar :any_skip_relocation
    sha256 "ebaacd7760cc7ebec4b0057473b8d880f2c6a046e0c194330a85dfc5e71c5727" => :sierra
    sha256 "9789972a22750df643b61cceefb490c0daa926bcb5c5f0d4cd11e8303a4879aa" => :el_capitan
    sha256 "67c8a0852f7c694dff9463a3da98df35ef3c115194ee61e93a4f77f2030b772c" => :yosemite
  end

  devel do
    url "https://registry.npmjs.org/@angular/cli/-/cli-1.3.0-beta.0.tgz"
    version "1.3.0-beta.0"
    sha256 "8d82cba6783c24bfc37cdeb95371a725f251aa2db3c426ba8a147eb62f308650"
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
