require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.8.1.tgz"
  sha256 "a193f77175b5613482e1005f11eddb76b7bd976a394ec7fbb7cb43fee6691dd0"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bce430525013cc70bb8a48190bc9405ca244eaecff49cca6d22f9f6a066ce8d7" => :catalina
    sha256 "5c928837329913e69c689926711114babb282fe6b9d9ce8407c84e7781646a7a" => :mojave
    sha256 "1671923c36d336a4a901f61aba82ada31e9158ebbfd80ca85c160de3d493c261" => :high_sierra
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
