require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.2.3.tgz"
  sha256 "c5b00106a1499618eb95877b8e6b37b7c7d3fc290916f4e3439e041b663faf4d"

  bottle do
    sha256 "f66c6cc609e70b76f7a038354c59d7fbae09274cb5315974e81e6603cc908e11" => :sierra
    sha256 "7f0bfed1132112b482113338f07b237fbe7f3c0ed64419d88eaed7fe445b5e43" => :el_capitan
    sha256 "4a38ed5e7022583c6deec81eaf33cbc7e3575bc64c62d363b62de8060bd8354c" => :yosemite
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
