require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.0.7.tgz"
  sha256 "46f6bc79195c0026739b98a91084345cee1caac71edcd435f1ab97ecdf8a71bb"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a6ffeb4a79fd66d377d23a1ee68fe9cb7d6214751c1ddab830071a60ef33534d" => :big_sur
    sha256 "8de54c8d7fa6e8fcb5847f6fb96ae9bce296e69998c235c6bc7e6cf99045d4a5" => :arm64_big_sur
    sha256 "7dc78f4269d43a85ae067f07483a3e0752514f42d67c677ea4c6d3b22ef36ad7" => :catalina
    sha256 "033f92f56b43ce156e4dd5460682d2f1c5f84427ed864bfd625227e7d8e1eb4a" => :mojave
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
