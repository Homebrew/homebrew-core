class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.2.11.tgz"
  sha256 "91d0d5d88a2fd2e49ae3fd470af683d4678c769bf19456a6b40bff5a9d151406"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bf6c2d800614ab6c16de30f10fc5b80c1a5ce32438f15fdc884430c63cf49c5b"
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
