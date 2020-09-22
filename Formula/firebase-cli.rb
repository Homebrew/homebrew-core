require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.11.0.tgz"
  sha256 "7390ede247f9c44f957a9eadb85a5a925fbbe9de2b49970875714bfb9638d658"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d495c11391407d9386ebc336c7db3d76ee49a6f0d0aacc149f976281f5e03d3f" => :catalina
    sha256 "4589efd24eb7f0fbdcd6e5c16707735984352e692f536e60fc5a6f63c11d0de2" => :mojave
    sha256 "673a8e767742090103c662c37f7eee88da14831c7c281b4e5aafffb5bd0fc278" => :high_sierra
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
