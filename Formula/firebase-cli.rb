require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.16.0.tgz"
  sha256 "940ffcc58e7f2c55dc674653e786d4f1d4932d1565953585dee218f7c87f47de"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "a7acbb9b10ea392fc827a17739abc172d87ac4ba11618328e1d588fff014d442" => :catalina
    sha256 "3a5bfd216118f6bbc5243816938cd694c1a1caf3f69758a0436d2c9bd020e615" => :mojave
    sha256 "ea7f0e2ac0fb04be11c07daba842bc54f766b450bcb6a8f321c87daabb38a5f3" => :high_sierra
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
