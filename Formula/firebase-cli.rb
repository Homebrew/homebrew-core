require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.12.0.tgz"
  sha256 "d4dd900039c30393c5ae0c69f70872aa41b5c00fed5798d5204166210a74d327"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "76b6cb73c565afc2ff53895c615568e9f776a1ccc6e20867c9e3d7040b509067" => :high_sierra
    sha256 "ab3526fa51b0ce5da0637a55e92d8ae0262d7fac1aed724dcf280047cf4591ed" => :sierra
    sha256 "381637cdd9c825f81f06e7cc0cb8fac33d7c1be0a690d357512446aa6d1a52d5" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<-EOS.undent
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end
