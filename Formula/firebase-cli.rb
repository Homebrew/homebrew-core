require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.4.3.tgz"
  sha256 "11b58ebd0db07668b710ac45e9399684d78577207191a0f29a4d9813f81a86a0"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e71455e8731176b665232fd3ff9f6062bf957a778375af9fe58b24feac4bf64c" => :catalina
    sha256 "362209bf313f7726f729490cbfe072342db22cd08d86490c08046c4110aacc39" => :mojave
    sha256 "cedd7722b0fad1de5e8c9d9f4eb5081f42ba97c95983a1874bdea9c0ef85d2d7" => :high_sierra
  end

  depends_on "node"

  uses_from_macos "expect" => :test

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
