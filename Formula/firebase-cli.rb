require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.18.3.tgz"
  sha256 "84b933922771686a207f34b9db5415bc709ae520b5f070d1f0eb4c002d7f0291"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1657b6f67c61cd1847dcc0201644dc4df6d1e79280d05184bcf81c008f70f7f1" => :high_sierra
    sha256 "93db5dccf277e005c0d54e535e2ac48fe03f009c9fb6088e880dc005c6b3d16c" => :sierra
    sha256 "3fa05141d3be1d2dcc932f3644f34ca08e18580339ee5f1049cc41e75555adab" => :el_capitan
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
