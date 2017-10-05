require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.13.1.tgz"
  sha256 "0753bcf566e0d084404f9861bc70f21d5164e09eb03e6e8ca7e442337409585d"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "44288e101a13d7123f8cf5d4672bcf60b33c1c5bb079655bcc467fba1cb43067" => :high_sierra
    sha256 "e31150a4705268d78825614d8db8ad2f31c810717043cc7b32dba5c679d08941" => :sierra
    sha256 "7678d0be33da98fb0c0f279037acedf956940ce2d754999307dc07d8f7678b73" => :el_capitan
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
