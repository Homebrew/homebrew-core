require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.10.0.tgz"
  sha256 "2246f251e278b1429123739defcf259de77a00dfb9fb7f210fdb613d999867bd"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "b2f38e71015e9daeead95922ac1b974333c60ed94e7189ba0d1fd38a76a11985" => :sierra
    sha256 "9f8dd6678bc94dee434d02b31f03f930b438a9e17208d00fa359c4b9d5a8d85d" => :el_capitan
    sha256 "f8cc9f746562315a3d8c09e358dfda6b08c08deb8b857fb4ec59e4768ffbf3d9" => :yosemite
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
