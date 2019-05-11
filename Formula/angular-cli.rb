require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-7.3.9.tgz"
  sha256 "d9cf779176ffa78457b32564ce408317c6bf0fbaa945de63bbf56dcf85e6b6a5"

  bottle do
    sha256 "9f2b5899e07e3ce5a5131d6addc347699f91720e27a203d6eddd024ed991548e" => :mojave
    sha256 "8172d343267085939dfcc28efe810536fed6724e8094890af74a42f3d8138e66" => :high_sierra
    sha256 "b04e51a783f9ca862d76cc68885a9310a6d3e30362cb6d3ea3c6cd806927f21f" => :sierra
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
