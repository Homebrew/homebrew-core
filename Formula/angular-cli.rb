require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.4.8.tgz"
  sha256 "4730522009bfeaeaf681238f4ebaa318f842c5ed5367fc8ae7a0220f589a4d4e"

  bottle do
    sha256 "340d9fb594f59d56101ec989bd157fdb98092c59a54b7a71602ffb433a4192a7" => :high_sierra
    sha256 "664f7e2d0e1ef456194ecf2dd02f497522dd3722dc03f937c6e2cbfb7a6f1e00" => :sierra
    sha256 "ce6446e0318ed8f6431df396cbb79e999764b853c90481e5d808f0498802214f" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "--skip-install", "angular-homebrew-test"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
