class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.3.4.tgz"
  sha256 "5970ed10a3eab0e53b637e521b6dfef6ccd6ce1c8332cfa8db59232f771c3d83"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9b79faa7c40fcdc8cc419c8f7085abda60535e274c4c7907c581b7c61f7f40e9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end
