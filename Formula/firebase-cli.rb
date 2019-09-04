require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.3.1.tgz"
  sha256 "529f0d5367599bac832f4631b87315031027e42284c46d1f175e975c53fd10c8"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc9e516292a6ee29111bacc261c4339e5575e22edd9b532853d1a40d4557a02e" => :mojave
    sha256 "1f0b0c1a3cd213d8a579191034a638c2b3fecc3173294de635416c16425ec07f" => :high_sierra
    sha256 "8b9af90fa76d4d350db6af94a7eb8609157f3f2594477ddcf8eeb5799e9194a6" => :sierra
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
