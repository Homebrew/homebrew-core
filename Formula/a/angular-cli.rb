class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.2.2.tgz"
  sha256 "78a0892328ea479df66041612703e2d2452a416fdce322d2201a0912760cdc29"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c8ac1e12333970207e14f2c813118805c862e364112360b2c2dc29d2f581d87"
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
