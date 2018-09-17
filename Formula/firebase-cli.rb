require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-4.2.1.tgz"
  sha256 "f4ed23660fb4cb4dcb8ecfcb8e32ebc9a7323de42e661a9fa8dfcf4e370f21c5"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "70729d840f1bde40db25351808102c724bf45f6ae9af9a9433c414c860b9c726" => :mojave
    sha256 "779f2666b3fa19664fba952e41f9fbe28ff281781b4cbc4972ef89d08b2f0756" => :high_sierra
    sha256 "bbbb211ca0322630969ad9f79bf7a3fa46cf3c13ce30defbcb32eb41a5b3dcac" => :sierra
    sha256 "c7de2b83374297cced349be4249b89e4502eb56fa28d0ca58a66652d52d8dc60" => :el_capitan
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
