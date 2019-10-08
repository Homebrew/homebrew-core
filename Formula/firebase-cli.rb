require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.5.0.tgz"
  sha256 "bcb2278313a2a8db873e5e402b8531bfd90ef7dbf9ff591205468d127ca41e4b"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7651114654b054fb08358a30f008b9ef86dfc89ce55a88e48223a47a3d717a06" => :catalina
    sha256 "d071e8c1f7f720adac3c29ce74246de2a85549c4a8f85a4cc89fc75197c23c9e" => :mojave
    sha256 "610cb27b9dfa3ce63d078bfd3cf6aabfb4361c3f9446148285a781a58b7464a3" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end
