require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-9.0.4.tgz"
  sha256 "28ba5f8f932b81bec1583e5d213bb8e103d863d6307f030784ffd8a1b6b29129"

  bottle do
    cellar :any_skip_relocation
    sha256 "76468fde5e2592b5e32650fcb84448a4d6709d1c46be3976263dec53ba009d35" => :catalina
    sha256 "d0d5b02fb196458602ff95e5d218024f0866918691697384176430da08b9939b" => :mojave
    sha256 "b65cce5946b90ee76ec61cb0cb5bd7aedaeffafb947a5283292957199efca3a2" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
