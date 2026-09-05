class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.1.7.tgz"
  sha256 "4275c6252fce9e0197570bca657fbda1658d453be3aecb99d7274add86a51c56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ad7ed90ebe0047b8744aa05e78048e4aa0606fe00336785e728058063161fd63"
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
