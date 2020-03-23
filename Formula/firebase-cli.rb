require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.16.0.tgz"
  sha256 "5f413455bad33cb1ee0160735a084e9b6aea4de2a5f1d88969d81f5b91bc9455"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6176f341e09dd97ef41a9386d4ca4f6fb984cc789b7b7bcad72b942349459822" => :catalina
    sha256 "dc4c99c6cb96436327aebe582a69eecdadbe64cc9e4a1ed86d54b1d9b8bcda3d" => :mojave
    sha256 "048603c7ad007129bfa69670cfe86a64612e067a1137f2395cb007282bdb71ed" => :high_sierra
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
