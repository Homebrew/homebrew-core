require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.19.0.tgz"
  sha256 "bb98bbde563f99f0a033a6aa27ab53df68c0d3cbb6fe6edff598a54cb8fcb815"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cca3a268f2736456a49c6f05259f92406697c23bb30b532dd74bdbe4434fd72c" => :high_sierra
    sha256 "19aa91b453d843e156a2eb6cc9f454e3a9c86425cec8c8b4ef700cb4b1d75304" => :sierra
    sha256 "8f2209497791666f40d1340b480805e57d49c31b902851970b04c77a978627ca" => :el_capitan
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
