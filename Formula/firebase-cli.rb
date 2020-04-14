require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.0.3.tgz"
  sha256 "4605244f0e6ba7d6b9b034e662c3e086a77ed5f297c343d63c073b56c1e8c69a"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "97fa8ade1634f7b2ffac966e78d3384a4f9bf890c517967fc5124c10665f8497" => :catalina
    sha256 "1ab9ddb44809195dca777e1bd652ea29b59fff706346ee7a49d25da1ff1885aa" => :mojave
    sha256 "ad228f15b04dfa45e5a0cd8d2a1314c1f6442b5320326831c9afeb4036f90bba" => :high_sierra
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
