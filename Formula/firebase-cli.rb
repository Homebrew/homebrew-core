require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.3.1.tgz"
  sha256 "529f0d5367599bac832f4631b87315031027e42284c46d1f175e975c53fd10c8"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3186c9beb79916e24c3d3ed7f533be8ee19fbbf0b2474ca9030e48231545618a" => :mojave
    sha256 "b442648d7cbb2c852f7d82365f59f7a40c9ee641f3b41f703fc81c5019fdef84" => :high_sierra
    sha256 "4d3b429771162728d375a9d659b239c1c0e90fcd85d9f09d85323f9ecc4018e5" => :sierra
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
