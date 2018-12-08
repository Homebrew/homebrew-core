require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-6.1.2.tgz"
  sha256 "b0e0cc59caa7ea07ece169de55a51837bfbe0d32e78118378414c2ee2f8437cf"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3d6de0aa75d8ac7a4c10f3c980a61458db8ecca19b78a9ea6472b5e1defd697" => :mojave
    sha256 "0a0faf65135c613191bfea74675d96c823531b5e310e64dce146ff389c9dcff7" => :high_sierra
    sha256 "3eb3b361a48f4e98942fa6f8208dc1b4e4810ea123d7494c92a1b4d6b0e0b054" => :sierra
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
