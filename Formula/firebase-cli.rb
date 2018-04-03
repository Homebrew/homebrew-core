require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.18.0.tgz"
  sha256 "0e62e73ad90b96e52386c8c4ebf152b3209e249a09c9f9594ee33174575e0a12"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e241a2cdcb3d59d51fd4adb440703ea3d18515639a27e04936a631db4c693923" => :high_sierra
    sha256 "0b9d8e73b946117815ffb4ade6e2528bd7e51ff45fbfa28e6c36c4d96dbb68b9" => :sierra
    sha256 "59ebd6d8d3981bdcb99ef65e6f05153ea29da000c300340fba5fc204a594834a" => :el_capitan
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
