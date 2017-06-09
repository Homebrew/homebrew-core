require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.1.1.tgz"
  sha256 "e3169b949de5449ab27baff31ad4a70ad581befab62c0bf5d669c1056d432729"

  bottle do
    sha256 "e296575242de64ef7a1518259812a52b0fbc982f0add7e4888e3f159fbb8ceb1" => :sierra
    sha256 "c01e8e9859d86e0e941aef50bf57f16ca9f1fbb57d863e8ce4bfabeec0c5d80d" => :el_capitan
    sha256 "08736aa8f515c8b543b1e8160283f88872a731218d659e223bf620abe6198aaf" => :yosemite
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
