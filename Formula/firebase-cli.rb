require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.15.0.tgz"
  sha256 "b03f2e278d0400d47eeeef11b5c4602b5d7576d0abdcafa960a414bacd2d376a"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "3631ed37fc9319b13f2654af0395e86742ac6cdb1551b9b3953c25274fcbc1b4" => :high_sierra
    sha256 "c50ff922095fa921aeaa724d6ab96763df68f4e1b7730b0b2b93be72524cb48d" => :sierra
    sha256 "71773e8c93e146a8af2fb70e1da0c159e00cbf684801f686406df01a5ad8ce83" => :el_capitan
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
