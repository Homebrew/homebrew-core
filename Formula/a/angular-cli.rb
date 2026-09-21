class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.1.8.tgz"
  sha256 "f9cd77f2b7bf9a62b06d2cfe6e9a029e70f24c37fe9d5663a14ee75a36e4a975"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d257e1f124114e9775a63b480bfaab1e282a1f32399b9fe75761c591dc47c537"
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
