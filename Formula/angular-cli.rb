require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-9.0.1.tgz"
  sha256 "ca27c3fb0b8cd95b2c43a64f219fb8b08e8949db632a6a3dc35560b55a494b16"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea1ed2d71250d8a329a274f55124b7920dd795b89c4e281f7ee1d6f9238e47f0" => :catalina
    sha256 "caa9c0e40ee3f006907b6ead7b42f2bd068c3f6bd16dfd03dcaf8e111ec58e9a" => :mojave
    sha256 "c18e4c5e53b2e04bb0949002ad75325e5cf1d548ed4295618e9437475831081f" => :high_sierra
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
