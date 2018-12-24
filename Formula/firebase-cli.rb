require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-6.2.2.tgz"
  sha256 "3fc32719ffaf93d75f5ae71f909bc53a05efebdee40f608b92501b03d5a9e72e"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "157bc21bcef046df571bbb8453e148de7157b956431c4761cd3b8b3d9f8ec80a" => :mojave
    sha256 "9545a172dd00b5ff16f4cbd25e089b129c4273870a1fb2fa34026a7f416bf277" => :high_sierra
    sha256 "f98a511c480ef428cd70e5ab8b67d7d6ce6e791057a833ba2c0171cd230d2902" => :sierra
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
