class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.0.5.tgz"
  sha256 "580d0777edf1ec46ebdecb4c0f59f6cfda571141f2936a803e22fdfd8d72f7be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c4724eb761d0d3094d81c386fcb2b7ecc38ddf2e721ee78b26654330002cead1"
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
