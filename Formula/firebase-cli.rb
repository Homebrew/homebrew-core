require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.15.3.tgz"
  sha256 "1a902cff4a7f2e54980aed8ecc1eda5b09ceeb52ab966847a0300d0f13a7c851"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "993ce2ac1f32756e20b4de47fbe659a8b72a15ac54298371196611b0d9caa23c" => :high_sierra
    sha256 "8e1e341d4a0b4c78f3bf2e3c5eef1c47c4a1c5028d612bee61b6d354bc25e68b" => :sierra
    sha256 "6ccd9734ad5a6ca060d07973bf2ce5555e2459c42612ec6a40daf28fa957f837" => :el_capitan
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
