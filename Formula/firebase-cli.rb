require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.18.1.tgz"
  sha256 "293790cb8e6e0a4b96230f9a2c64ec386b4176017cc7d7e7ce20a953457c7880"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7ba41bf1b957e59e05c4c8d36deba989b86181b825d1ab5322a8cabb3b2ec51" => :high_sierra
    sha256 "877bd3d0b0782007fb836ca3061900a35548bf64dc1499ea8cbd7d223861f32e" => :sierra
    sha256 "285d8dd8269bd8b35f6c61e4f942a0139579735d2dfdeb6cf9cce1a93fd9973b" => :el_capitan
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
