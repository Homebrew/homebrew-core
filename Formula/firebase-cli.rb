require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.4.0.tgz"
  sha256 "19ca78e8a0b487fbca8a30391d2fd08cbb4738bdbf06654e1ad9e77f6ed6859a"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d653b12792f451899142af2553a9de8745cb1fa04bde7781023b1d9038c25e3" => :mojave
    sha256 "c30d8275a679ba0b77229105102ce07ddbe494889ef56cddab17baaa20565917" => :high_sierra
    sha256 "c5cf622bd1eca1143773a81fe310ef303cba7ab18a0b8bccc4f484ee985f1f91" => :sierra
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
