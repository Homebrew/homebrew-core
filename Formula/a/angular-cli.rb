class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.0.4.tgz"
  sha256 "63c895d36b4c3366a670c5d26cefe2bca32e7ffa93034286e9a6ec30bc05c190"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "00b3b31acdf47f5cc4f15ccafc61011fc8d1bd806ccc07dda529b752f2ddd5d1"
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
