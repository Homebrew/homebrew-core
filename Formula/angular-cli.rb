require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-9.0.6.tgz"
  sha256 "a1d5ff1a5b01de10daec715b5db768b1e16178f8d4262aa7973ff3d1204d852f"

  bottle do
    cellar :any_skip_relocation
    sha256 "08514d96af80ba5db46382e5315b7bdb2832d0b03ef406c5d2c8c42870e0a7de" => :catalina
    sha256 "685efc3f60daaa9531274ed20b8c69842e4fc8a84ffdda0dea0040638335185a" => :mojave
    sha256 "fb02d0893a9abe61f653c8bb58bcb009b0289f7076787028dfce120d4bc97a62" => :high_sierra
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
