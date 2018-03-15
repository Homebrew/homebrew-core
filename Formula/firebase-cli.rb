require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.17.6.tgz"
  sha256 "cbedf66f0a84f7e3d444cab7f67b17f4565fd26540cdc1d231eb3cb6c7c0d12e"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e178949fd0962c31d300fda96d3982cbc008d032a4f1dc3b8a2bcd8d33d7038f" => :high_sierra
    sha256 "eee7b512050caa3fb6c56b4335128e16ed7ee330809bf211461c395e13bb2817" => :sierra
    sha256 "3b5327357923e414133fc85636974bc6a79ca7bde9d47cc5c7a91fb3ef1e8dd2" => :el_capitan
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
