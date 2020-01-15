require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.12.0.tgz"
  sha256 "4713a1ef8e974582ad7acd011c3ce591e7310f8c2f9aa4ff1fcafcb918990f69"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "111c0eeeef34cf3ae079a9483eeeec00b00d2fed1ecfc6cb2bdbb2a727db43bf" => :catalina
    sha256 "730fddab6551cbe07f6af24717d33f6362388c9c8f3c20b9d5c2783bd1b3f2a7" => :mojave
    sha256 "4126798a0d9574615e49ddde5f337d9c866ed05c1168a065cb0673606603909f" => :high_sierra
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
