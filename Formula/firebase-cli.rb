require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.15.1.tgz"
  sha256 "b62413db55644154161a2692b10d67b9ec7fecce220ae10a49db4e0a38e6f01d"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "eb6baf93fc6d31c193093ba01ff357d0938b9b72d9faa097f60155d08eb648ff" => :high_sierra
    sha256 "ce2f97e2760acc73de1a41b7c1d5ed6e4e6ce8e287958b9240929a55e7550714" => :sierra
    sha256 "fa6da0c13d9bd0305fbcfd7ebcd6885b40d4c61595ba5affbad5c526600a33ec" => :el_capitan
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
