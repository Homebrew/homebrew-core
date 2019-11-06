require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.6.2.tgz"
  sha256 "5973136a596738b2528307815b6fbedcc4cb25a663ffdd292c66146e0fcdc8cd"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "87301fd6888652c0ba0f762726e46285b6c0947781b390e6e1e83d9784220f6c" => :catalina
    sha256 "68a28e525fe774b52bd0f824515dc9c40cd50154366be231f097a4114c05101d" => :mojave
    sha256 "b49ad6db093996a7f2f7041919fe864f19d41b913ed839531425e7b92a8a8e4a" => :high_sierra
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
