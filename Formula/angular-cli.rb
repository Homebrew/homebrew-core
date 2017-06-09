require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.1.1.tgz"
  sha256 "e3169b949de5449ab27baff31ad4a70ad581befab62c0bf5d669c1056d432729"

  bottle do
    sha256 "55cafefcf46f0fa3680662f35aaf731da949dc0dda8806c48ca285ec45acf836" => :sierra
    sha256 "4e9620632443d8722a0e4bf5c3da09789c927f2c13193a302528e2eaa4719f2b" => :el_capitan
    sha256 "06ea4e1058df34c17143ffd7df94d2682a1cb709c84149785d516a5207dee0d7" => :yosemite
  end

  devel do
    url "https://registry.npmjs.org/@angular/cli/-/cli-1.2.0-beta.1.tgz"
    version "1.2.0-beta.1"
    sha256 "12f14eee86ed3e30866b5fea0caf2cd2c6f8df5a1d9a289af4d9915430961a68"
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
