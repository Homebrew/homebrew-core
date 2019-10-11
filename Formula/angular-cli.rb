require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.3.9.tgz"
  sha256 "cd0f7dbe537e76b0f7164a927684bc20c3c446d63dbc731ec68e79bcec553922"

  bottle do
    cellar :any_skip_relocation
    sha256 "92ebac6a7f8fec77c7cff03733f1f4430caa4992d01131557985a09c5dc3f701" => :catalina
    sha256 "f993f195ff91c9de33445a1b589dad64d83817f879e7c4c1101d39c2332e3453" => :mojave
    sha256 "21262ceaf2f64916a0bed647d93e29b2bbac2fdd7af6b633e557f9c10d13819f" => :high_sierra
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
