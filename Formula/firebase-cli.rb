require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.21.0.tgz"
  sha256 "a459b676506a8e5eac6873114ea060ee37196fb6bd0e9ed4750dbe423e950c2e"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "06e5d17ced341c87837bf2f62571d025fdffe6a66059e013c6434c634366973b"
    sha256                               arm64_monterey: "29ec8747e934ee232a9c01845affb85a68749a80770c990516fe5358ffd3af72"
    sha256                               arm64_big_sur:  "18dd41e334c94d734aea17ebd3a02e8102bdf9adab3aa46844d331d1b7060cc2"
    sha256 cellar: :any_skip_relocation, ventura:        "bc225060dcc4b7a2c01d543106ead0b98ef03ca1aad769000fcae3150787cf76"
    sha256 cellar: :any_skip_relocation, monterey:       "2fe93d13ab604ee8b39ffb7e314219ecb9db7e336fa29d595baee37e70a833f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "2fe93d13ab604ee8b39ffb7e314219ecb9db7e336fa29d595baee37e70a833f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feb2668a2a1118913daae6779c86ad54196282c1eafa5e7e2d8e8230abb0a21a"
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
