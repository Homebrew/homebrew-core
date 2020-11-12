require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.16.1.tgz"
  sha256 "5ab73b5925d67a5a7ac5e4039c767fb5ece2b5a17d46ebd01db074b86171df1f"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "b48095af6632e2f88b313316c6b56042abddb3dd85a3badc56af52f57bc15287" => :catalina
    sha256 "282b796a283a23ef2c5416d7ccac64ce1a395ccbd06da03bfb5cb07658047747" => :mojave
    sha256 "03ab654a897a5ced702db6ea3e488d1230b5f47c1bfedaefc9813b8ade35ff9e" => :high_sierra
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
