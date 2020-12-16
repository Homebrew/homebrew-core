require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.19.0.tgz"
  sha256 "d2ff826dae76f9b9f78ddf81d4041354d38a55bfd45b867769e40b9fb02774a4"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "312c94927a957d6f3f91950108103fcc1a1f499170135fa1d46a83027cdae4dd" => :big_sur
    sha256 "d75b53281f8f7a8e7e8a2af9d6077e4b5e79711a1e5b53323dc2908524418c42" => :catalina
    sha256 "aa281a50a175847333b9ec519039f518c31860a8ead06df5596f2446d94a20b0" => :mojave
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
