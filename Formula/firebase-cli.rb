require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.4.1.tgz"
  sha256 "dfc15bfb0710069e460a34c3df0401ecfef6e1bb2bb1da0795d7284be870a0c3"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0841119767f70b1ee43a1be846beec5d003f1bb9443c0c7f2c570b39f2ac6573" => :catalina
    sha256 "bd7a179ad08ed2bf7592083d8e170b583687b36596565ce5300c89f81c1a8dd7" => :mojave
    sha256 "332fab630e887b8265931652bdd96407fb90a1ca3d05f32ffe99396c187d1d74" => :high_sierra
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
