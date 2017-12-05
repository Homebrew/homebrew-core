require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.16.0.tgz"
  sha256 "d1d466497eaaaf9729c2128b7ba1d27a51165cfe9728fa311e7c259ca5acbd01"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "0af9314a8934392c82c8b5ba3034bc88de6492181cea43f6f7d9211527deb706" => :high_sierra
    sha256 "b6b1ca9ab2d671bc2f26f57e9cf250acb778bd9cc2a2bcc08467744a498fe7b4" => :sierra
    sha256 "122f105fea5f45b00fe122bd12694d2ccaf09c11210e4fa06615d66908260409" => :el_capitan
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
