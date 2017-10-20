require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.4.9.tgz"
  sha256 "4769dd70a0b0adb17c3e32aeba7bbc48febc6e0e91f7f008df2436e5c0402473"

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
