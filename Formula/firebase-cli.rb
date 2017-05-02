require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.6.1.tgz"
  sha256 "0235f8752d8ab7db647c07a255cfbe0a3db62c75e770595170fb9126ce8456b8"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae707281f0ec9d5258de00428f7f4603342a085863661e11a943b79d6f845122" => :sierra
    sha256 "5ad10fb04f6eb3a4aabb105704590fa4b38c283b7a5e42886bf292f71eeab4f7" => :el_capitan
    sha256 "7f5b2ca0f4b17f5161ae051ee692002b9181e14d10955ab2e9f69473441a2967" => :yosemite
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
