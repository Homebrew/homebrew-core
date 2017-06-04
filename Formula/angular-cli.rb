require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.1.0.tgz"
  sha256 "5df88cf1f3452c68caeb85c7f3283b366fab059f1d522dd3414cd498a92a3c97"

  bottle do
    sha256 "55cafefcf46f0fa3680662f35aaf731da949dc0dda8806c48ca285ec45acf836" => :sierra
    sha256 "4e9620632443d8722a0e4bf5c3da09789c927f2c13193a302528e2eaa4719f2b" => :el_capitan
    sha256 "06ea4e1058df34c17143ffd7df94d2682a1cb709c84149785d516a5207dee0d7" => :yosemite
  end

  devel do
    url "https://registry.npmjs.org/@angular/cli/-/cli-1.2.0-beta.0.tgz"
    version "1.2.0-beta.0"
    sha256 "392898113077fdc5bf2dbd3591b54bc371dee870a1d343fee2d6ccddf2677f6d"
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
