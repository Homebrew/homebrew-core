require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.4.0.tgz"
  sha256 "daca32fa048704f9eb16bf410cc78c4d95fdddb9026859cfc172cd365e7feb94"

  bottle do
    sha256 "f21fcdaf492e0077d2249864cd3430dcac8e1541372e4948c765a46f9a16f10a" => :sierra
    sha256 "cedaf42d3f0442cf2a3d86ff4721d809a6bd016b7b939e00d55da8d6e0b21294" => :el_capitan
    sha256 "9549de0cb6f23363422497482279a3af2df2fd254760c76c40c301b3d78224e1" => :yosemite
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
