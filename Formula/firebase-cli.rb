require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.15.1.tgz"
  sha256 "56af1bda34de229e39e2131b26057faefa90ba05f470126eedcc3d31a6d61987"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "62d612989559850f5084926d56a5b6911227d90a0cd41a9249ee6cfa02f499ab" => :catalina
    sha256 "6e9d1bc836930750536ec9240674b0bf7a45458f618ab181b80dc6be797efb5d" => :mojave
    sha256 "13e51a058195f4773d8ae2f19d3bcac0d1187aa6f6d61ad0fa7342da18a2ffa4" => :high_sierra
  end

  depends_on "node"

  uses_from_macos "expect" => :test

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
