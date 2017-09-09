require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.10.1.tgz"
  sha256 "1818e4046cd24bc3b9a25acdea9e122ab61bf2bfe9f6a2179f1cc2546402e65f"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "55b0e97b973af02869f936fdafbdf690d74e93be6341b7a370c1dd69883857c6" => :sierra
    sha256 "352092effe11f577703ff275698e4bf13f7f3492fa7dae41cf5442a2fcf8319e" => :el_capitan
    sha256 "916100744a994c59dced42c8722d1ce12d22a6a4ba24997db4d126b1feb98130" => :yosemite
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
