require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.0.1.tgz"
  sha256 "888030aa1296a0b1124687db293dd0fc2b9bea030619617db31126587da44a90"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "f38d62b743da38647b33717a2fa45b9511c0e91b6b3ad2614f8a29d03bab5976" => :mojave
    sha256 "162f4bd70830bf419b44706c1f56215f6eca9afbbfeaaf9d36c9a4ce71a8c66e" => :high_sierra
    sha256 "415f39226a5b4f2df3c41da3b51c123a768d69ba3cf76632a95f8ed08f45108c" => :sierra
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
