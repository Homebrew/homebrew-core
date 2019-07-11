require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.1.0.tgz"
  sha256 "7074e2d2de7ecf6b4f3cbffea27e53bcf03404b2e632d891ca2549e9baf0b2b1"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "d65281fb320ca0c9b97b90c7faf2b0f80ee26ead8041d48a6ed6462b19991e6e" => :mojave
    sha256 "a7abdbc47dbc2d4ae138c01cc5fffbcc137d064c62076d1988da27eab96a3ed2" => :high_sierra
    sha256 "8846b7202d774c796f9a58b42090bdfa2026292fcd78e4bcc01982b627782430" => :sierra
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
