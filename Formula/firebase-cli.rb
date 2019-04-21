require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-6.7.0.tgz"
  sha256 "a290243a9da1fabd883640e0da45f9b0a1d381c826e8b7d67c18c1e5ff997894"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "44e434d277a018d85f2a7b2f38da75787bd8b7d6e693836ce62d1c521a05cd65" => :mojave
    sha256 "05a0f5a1d9464e3b5fc174bb21728d27116e4152ec872a6d155e2a90edcd35b3" => :high_sierra
    sha256 "b3b35958889ac1c33aff5d1eded3d79d56fb5ef997f8975300cbd9c14fc3590e" => :sierra
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
