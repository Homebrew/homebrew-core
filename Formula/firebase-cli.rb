require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.12.0.tgz"
  sha256 "4713a1ef8e974582ad7acd011c3ce591e7310f8c2f9aa4ff1fcafcb918990f69"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "01b7f27e0f7b41b7dc8e7dc3534ab7dc87c4629bea6f40efbab35f1776264a0a" => :catalina
    sha256 "90f918937ff6aaccc230f6104b917313f68766e18fb652740148a4d0e4b628a7" => :mojave
    sha256 "fd00b5ac62c2dfbe66b4725d12e56988b74f4025b378b5fa0bea58644cc4c943" => :high_sierra
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
