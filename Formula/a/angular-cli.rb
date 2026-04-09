class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.2.6.tgz"
  sha256 "bf92c991424375d3c7d842b9515150df91e7b161c1efb59952e38a8c04e75b11"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "804c9b9f5a1509ed021845c665d9531de8fde13a29dffda74da40f1269f0aa89"
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
