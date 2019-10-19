require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.6.1.tgz"
  sha256 "8de6bd4d72d13410a493ed1c8ae3f0f657ebe351d73345620f1e707cebec24bc"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "52a8b4589132afc47e6c3348a629dcb117f2eda8aabf72e5c7bdcc482f44dda0" => :catalina
    sha256 "5b896ce875435da398fb2a1738f4ed2f83563d16a84ad5d8836e7264090cefc1" => :mojave
    sha256 "bed9710e0e2d60e2b7239e8b37aa1698ac395a8348463de03637bc55279fabc3" => :high_sierra
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
