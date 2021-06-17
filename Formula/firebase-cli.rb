require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.13.1.tgz"
  sha256 "7d78e97a78de80cb6eb275b8b4cf97cfb1c2df802f3209497a8d448343418c74"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "66fb0f0d3859d391feee2392a0ba70b1071fb1df28f71978801232ee79508359"
    sha256 cellar: :any_skip_relocation, big_sur:       "429aca4c12af62f94625d19f1c76a173591d11a1f3e194b696dccb001d446a32"
    sha256 cellar: :any_skip_relocation, catalina:      "429aca4c12af62f94625d19f1c76a173591d11a1f3e194b696dccb001d446a32"
    sha256 cellar: :any_skip_relocation, mojave:        "429aca4c12af62f94625d19f1c76a173591d11a1f3e194b696dccb001d446a32"
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
