require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-6.4.0.tgz"
  sha256 "6f9a57260cbc58a03e6925bb9fce997edbc3868c30539948fe04fa92bb7a6166"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "003cadee665ee69164b1bc80918435f5a77d7d5db0b8b9c7fd88e0b2ed9fc90f" => :mojave
    sha256 "c7ce479a743eb8dec38a6b68452f5b1c4b75097b25e0b64b8774b499f348d922" => :high_sierra
    sha256 "1960619984940a77aa7a1e6011ab3cc424b635d57326c2fc4214eb5eb7a3b3f0" => :sierra
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
