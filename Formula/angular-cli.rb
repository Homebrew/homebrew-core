require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.3.6.tgz"
  sha256 "5091c9468e66f435684f801628334d112ee1d9e1b72203b6acd853aa516e3d3a"

  bottle do
    cellar :any_skip_relocation
    sha256 "8acba34336bf445a2c9c746f75783d5c487b1f559d89475961693f11a2a91e46" => :mojave
    sha256 "56eacdbb26f09f3e4764a263cd1679e16cb40b1314ed3ceab6ee125db2f8d058" => :high_sierra
    sha256 "9df234e8d22da0a66a25d06c1b5425c7a3dc85a55c9b5f0eb3bc33484fb3de2f" => :sierra
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
