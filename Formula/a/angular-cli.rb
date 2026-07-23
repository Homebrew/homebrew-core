class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.0.7.tgz"
  sha256 "1abd74db8873cd1c7e6ab873504cea5522293758fb7f05513faefd941cfc33b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1eddb569950b5ebb069d442922e76ef0be84a7210e5a81168dd323c9c1297437"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end
