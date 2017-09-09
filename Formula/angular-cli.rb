require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.4.1.tgz"
  sha256 "eafd7ba18be63a4fa3e32ad11f45de8ab3111367f4fd8b9a132451932f1719a5"

  bottle do
    sha256 "e9d90a0ac96bb98fa259bb79a64febd193aa624e9ad66a94df040d3d9a124ac6" => :sierra
    sha256 "e06f19e366648b888f949ba0ecabe3d54fbafb39df89461c5297572d643743ed" => :el_capitan
    sha256 "ec2c8c269735f1b9293c378619c38b0a71ee18417bb50399f5f2f8b2ce134a4c" => :yosemite
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
