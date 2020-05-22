require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.4.0.tgz"
  sha256 "6d6e3bc1307e1948ba35f0bd69ed380eb4510a80e3b608b776097f8d26a14a92"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "48428481957656103bebeeb23ce6460440d3ed0fecf1886d752700174cfbc410" => :catalina
    sha256 "3fb88226a40c7b02c61706ce10a7f355dd8053add0cc6fd0104aa368f11f4511" => :mojave
    sha256 "baafb8446f8e703864be5c6d1af28cb9b7b9b6447e50556216fef13d85256fa6" => :high_sierra
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
