require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-6.1.2.tgz"
  sha256 "72be54e8777b1d9328164fa8274c979bff8e2c37b25e8b53c6d1c419f3a52e37"

  bottle do
    sha256 "21169e0c078d7b5a17a068af75cc6af98e5f33d8799a007bf73a3218334bb9db" => :high_sierra
    sha256 "1a6f9bfdf5983e1105e63c691528a54e7d2173cc08129a334401a17d7a94346a" => :sierra
    sha256 "ab8810e610c64a43621fcf5c1550781629f761a9b2624d8cfe1a6333dba74a26" => :el_capitan
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
