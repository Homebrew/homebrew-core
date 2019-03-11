require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-6.4.0.tgz"
  sha256 "6f9a57260cbc58a03e6925bb9fce997edbc3868c30539948fe04fa92bb7a6166"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ddcfb7eacfdbcd037613edb39b7de8939227e1dd81810b85a5cf5b9573554cf" => :mojave
    sha256 "19ba5260145d59b2b627d396ad5e56814563feb3ad46a3c454fa9f535a35f1d1" => :high_sierra
    sha256 "8ffe7804ba3c8b4bddbbc50d8c804fc8e2b15cc71aff1daf9ceee4aef02f9dc1" => :sierra
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
