require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.10.2.tgz"
  sha256 "3c012a0580a25984094cd613e8c8a1371ea60ebefe226e5945a5194b158958fd"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "06d613eb126755e4afa5ba60dcb91892153b7109de92021a6f3de6a6b3441d45"
    sha256 cellar: :any_skip_relocation, big_sur:       "398586a8c1542a592784d9d99d8d7dab75d150174a32577df6e65854c72dcba2"
    sha256 cellar: :any_skip_relocation, catalina:      "398586a8c1542a592784d9d99d8d7dab75d150174a32577df6e65854c72dcba2"
    sha256 cellar: :any_skip_relocation, mojave:        "6b9ccdaedd2ed198c5aebefafdd21dd49374699d0007d4bca37ee4cf431d274e"
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
