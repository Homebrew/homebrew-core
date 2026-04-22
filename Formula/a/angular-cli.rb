class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.2.7.tgz"
  sha256 "d66fcb7f2b40d5f21d63f883572ef3faad144b5fa95b60f75c59dbd188e58a24"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d2ad3866fdad9d271341f1937024819b64f0a65b09659dd457b9556e09bcd675"
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
