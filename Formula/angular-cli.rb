require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.2.4.tgz"
  sha256 "3c0b6d2f122f0419d046ce5dd8ddf2e1655e3197a03162ad80c88d7249e3579c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "802d649d03ae9b668c81e71a6e7dc8e269254b35373231f7f6d0bcfb34986c53"
    sha256 cellar: :any_skip_relocation, big_sur:       "1d770a41a5e3d2beb6ab7a8a677a573f845897855e03668002bfc77e00062fcf"
    sha256 cellar: :any_skip_relocation, catalina:      "a1615291ab7f2dc6236ac06ebaf8e907d59157e9868b2ca4e5b1de9442275390"
    sha256 cellar: :any_skip_relocation, mojave:        "c5009a8bb5cfb059428957963c02e12928f10064ac7695f0ed4d8279d7045567"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
