require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.1.0.tgz"
  sha256 "7074e2d2de7ecf6b4f3cbffea27e53bcf03404b2e632d891ca2549e9baf0b2b1"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "4588ef191a6905c12a55aea6cb7314ddab3206037070a08d001e15919653d2a3" => :mojave
    sha256 "4ec8b476521d2f42d25aef44ae135f64e26f2c6eb582fc4bb2791bbe73ed62d0" => :high_sierra
    sha256 "8cc86abad4748f324570513d565080b0927f891ee66b3b551d9c1a1c4808dcab" => :sierra
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
