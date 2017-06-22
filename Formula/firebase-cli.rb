require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.9.1.tgz"
  sha256 "e60e66ae5132817408622823f54f8a611ca459f5eeabd7a2e8f09727add83c5b"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "ff36967c70fa914b6c858ac0af097e8377dfb1fc8cab849bf2020ce55f7f157e" => :sierra
    sha256 "6f781f598c021d8765a53df871f330717ac5009d9ab55bdae18ac33f1b622a4a" => :el_capitan
    sha256 "0ceee8d1d6ba85d0c11394457c8e364b9afddf7a77113b1830112848f850f619" => :yosemite
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
