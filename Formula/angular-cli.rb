require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-9.1.6.tgz"
  sha256 "5a999d3c0832e9363ebaa3bf8d2f8f9ef872efa339df9d070592a298916cf323"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8947886d2ef45d85669cac4b56161909cb6b07a008ae9a59bf85e0420319382" => :catalina
    sha256 "34b2018a3f3fd5e97325ad7f26f1d833cc4a4582b3d9ffc9f527a4525e1d1e8b" => :mojave
    sha256 "636bffe230bfc16d17aa2c8cebebf3476a3b4b34557ed2721fdc95d7f4f31b1f" => :high_sierra
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
