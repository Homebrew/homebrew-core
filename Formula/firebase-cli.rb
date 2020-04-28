require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.2.0.tgz"
  sha256 "21a119f951b4d300e1f705c76313b392e003087825371a2cafe5378c3b4a1843"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e74495347d9d1da6e7dcc16a23d9f8170ad6cbbceebe01b8acd27ede7f7fd6b" => :catalina
    sha256 "7e5bb906e5c74cb8e2cb379bdc97ccafac12372f92cdf24b717d7e51e2c5a6c6" => :mojave
    sha256 "5fb5efa1138a479903cbc880171ce0dad0ed11d62907db2c0a19d7fedc57d7b1" => :high_sierra
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
