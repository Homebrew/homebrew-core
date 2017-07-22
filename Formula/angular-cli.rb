require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.2.3.tgz"
  sha256 "c5b00106a1499618eb95877b8e6b37b7c7d3fc290916f4e3439e041b663faf4d"

  bottle do
    sha256 "0f902807ae26b31e605d24078cfd8866e44d74e0da68183a58a00ba2bdcf90b4" => :sierra
    sha256 "fbc23dbe47d7ae155d53e11be4e0571ddb7b24efb2a69013e49d95871a4d0fee" => :el_capitan
    sha256 "69f3c507c315b85147f261a087e67ce1202f47be08669d9cc0ab4019b9fdd1be" => :yosemite
  end

  devel do
    url "https://registry.npmjs.org/@angular/cli/-/cli-1.3.0-rc.0.tgz"
    version "1.3.0-rc.0"
    sha256 "e1acc8851e6013f0819e7537c9c4abaa1b1d87eeb9371912bddbdcc8fcf31c3f"
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
