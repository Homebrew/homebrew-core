require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.2.0.tgz"
  sha256 "cd989a16b7e3e4c6ed6aa47ead2982bf28c1d53b29515c48559d27ada7768764"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "2b988c054d141d743d66624d7f3e9cf11b896779243cf9000be9bd276075edd9"
    sha256                               arm64_monterey: "53433f382f2e342824ddcf2874d5067c4e9eaed1c69bb5b9845fc4a47443f85c"
    sha256                               arm64_big_sur:  "afe0997ea690375c41b9c0d2cebf281097fea57133eb6181580f3052298bc7e9"
    sha256                               ventura:        "0f2aabd2218e4d853aa5e53b3489bf0ae6f8a23e0641ce5b2b1863a9c563cc1c"
    sha256                               monterey:       "32a8a97d590faa4d49065d05085081ac871f1c10fdcd86962812decf99b3452e"
    sha256                               big_sur:        "d01082b6a121bdb9375d19395054ab02758a6fdfc0abd83685c9dcde8a80e829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dd75247f8eadaada9b41fc6cb643b759d5d2c6085aa806b2171f84492578f9e"
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
