class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.1.5.tgz"
  sha256 "4e49d7e45b11bf26ce43d046619b0ad982a9e9d73f94cf6266f90c3f8118eb9a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "05cbae540ae083a894eb22bd77ec6957ebf4207c163877dde5595bcb7b2e0a36"
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
