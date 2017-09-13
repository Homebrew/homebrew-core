require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.10.1.tgz"
  sha256 "1818e4046cd24bc3b9a25acdea9e122ab61bf2bfe9f6a2179f1cc2546402e65f"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "19eb0b29c7b944c97db55dec90ec95ee50c1f4b70b49c568c4aa4899ed68105f" => :sierra
    sha256 "56cacebc5c66abeb303cf03d8befbb3352e0a432585dc3b83e9bd5e1b467cb9a" => :el_capitan
    sha256 "d827bc5a257d5e3b844b1b4f3e42b1b91e1f146487662d8eace1204d8093c2bc" => :yosemite
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
