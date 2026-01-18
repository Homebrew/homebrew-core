class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.1.0.tgz"
  sha256 "4ada380ba3ca3c4f1da079156fc6b67403b0f880cf1910f88bf67eaec26f83c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2de8e8e6c4126653196cf590f95b934a327abde386d899232e729cafb7469f07"
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
