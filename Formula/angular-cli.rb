require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-9.0.4.tgz"
  sha256 "28ba5f8f932b81bec1583e5d213bb8e103d863d6307f030784ffd8a1b6b29129"

  bottle do
    cellar :any_skip_relocation
    sha256 "3edb04b051ed183798d52b4ee0a4a9497192bd4c6c59631fc44a99846ae5ff64" => :catalina
    sha256 "8590bc8385a590accc596010d8b5fc405212a9bc5dbdc5aef7e1809349a7b3db" => :mojave
    sha256 "71923eb215f70d97284e984a298370acb0a155535b96c270c8b2854b8a2f7699" => :high_sierra
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
