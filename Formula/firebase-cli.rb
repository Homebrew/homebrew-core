require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.19.1.tgz"
  sha256 "0d39a4971b7da3a3b5f06199e28c2ec4ad8baea5c8bbdc247b8f3ae4bc47d534"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf42e09d8a818233cb38e0888dec3d713d76bbf8d7c5f8179bd97bde8018c1f2" => :high_sierra
    sha256 "d4ef3ace1666b50f8194600d13ce326b02cbeac91cd8c51531689212c52eb346" => :sierra
    sha256 "d5064dce53a5eb6e84f7f7c7cdedab6a590aeffb574e0608124aea941907970b" => :el_capitan
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
