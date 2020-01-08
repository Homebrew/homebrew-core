require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.10.0.tgz"
  sha256 "10ec69b5d47d5bdf95f5e2258d9cb944e1d76c13b32aef63b6485f83e89ef47f"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a52e435fb78d0b5ffa7f58703cf3133db17c31fcb5dee0d10f698535d4f25c06" => :catalina
    sha256 "3713a39d51a7cf428c70fdb004b51809d5f56f5d2a11e4c0c1536aee7a2828cc" => :mojave
    sha256 "fcba88f8d50870c0bd7340bbb30b81c8a5be4663dc1228645b49250ff651befc" => :high_sierra
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
