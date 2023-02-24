require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.24.0.tgz"
  sha256 "1c1c2ef32d4cf300e8eff2634fdd9645fa28c726fea019ebe1f781939edc9c2e"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "5d3e4d7891611525f408f8416303019fffccce918048f5c3dd907c702510d7ca"
    sha256                               arm64_monterey: "918752db8470d3d38e446a28e79c66b320a37d27e6a59abd2bf5a9146f3a60ae"
    sha256                               arm64_big_sur:  "ea791c22d063b456964c26209e71a94a57e459aafd1457d57035b50266b52b95"
    sha256 cellar: :any_skip_relocation, ventura:        "8c21bd2d075c68b1b00ff9d76bf043f610897e5e554b5de49dad3cc81e00faf3"
    sha256 cellar: :any_skip_relocation, monterey:       "8c21bd2d075c68b1b00ff9d76bf043f610897e5e554b5de49dad3cc81e00faf3"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c21bd2d075c68b1b00ff9d76bf043f610897e5e554b5de49dad3cc81e00faf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f18c4276a30217d71499c56315eae7478cd63fdb960f6fdc4dcf0c7cabc025ef"
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
