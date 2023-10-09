require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.6.2.tgz"
  sha256 "64f62b8e11458ba770ef4850777c6b263b2c6a52751da800a5a6cfc2d1e8e530"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b074ed3b62ae67d581f1f2041df1d4ce281205dfed6ec1a2b216bc3afa5c461"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b074ed3b62ae67d581f1f2041df1d4ce281205dfed6ec1a2b216bc3afa5c461"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b074ed3b62ae67d581f1f2041df1d4ce281205dfed6ec1a2b216bc3afa5c461"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b62872bc84051e05a1381500f99cb92059f1c88894e4b07f74ce486962563d4"
    sha256 cellar: :any_skip_relocation, ventura:        "4b62872bc84051e05a1381500f99cb92059f1c88894e4b07f74ce486962563d4"
    sha256 cellar: :any_skip_relocation, monterey:       "4b62872bc84051e05a1381500f99cb92059f1c88894e4b07f74ce486962563d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1577356a33dc7659ea6e063e9815eee5764882cd61c1b39b718187cc69934cc9"
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
