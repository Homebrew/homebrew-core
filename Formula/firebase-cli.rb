require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-4.2.0.tgz"
  sha256 "7be1ef39d70ca89772fe4362bf36d6afe4bf7f19d69d5629cc39d6acbc7b9593"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "85ea9af7d6767054ea8a908362c3d1779bbb1e8286ee20b66443672039415aa0" => :mojave
    sha256 "808187fb3f8ceee18d5fdab27135df4f602b55ea2c834a77b392301ba599d156" => :high_sierra
    sha256 "c3cce67792006397886991005e5d1591e681c6e52f0d8ea8dc0a104654284dde" => :sierra
    sha256 "48797fce2d5daa24e01f63949d69ee99bbebbeab430e65b48b31fc1cd4fced10" => :el_capitan
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
