require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.4.5.tgz"
  sha256 "1c400473cd08e80cbf9912fe0b4c62a86f72a617f48e40865361c2160d8432f7"

  bottle do
    sha256 "e5e2c94f6d892055fdb4f397fdc32f10bba9005f45845cbd34562fa5de67cd76" => :high_sierra
    sha256 "b1431ffed9802fb336bdd472d2aabec63f682d67f536e9d007f9bb1848861eef" => :sierra
    sha256 "eced7745eb837ed551534f290016d04a5fc44390724b5781256199e59a1eca48" => :el_capitan
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
