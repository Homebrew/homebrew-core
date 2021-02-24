require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.5.0.tgz"
  sha256 "a27843d0450b845ab550c3092511ca1198c60a978ea778095058bbdc87066923"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "4322ecdd0bc8929ac4f58294d75fafdc73458482f97016fc09023c1e88fa0ef7"
    sha256 cellar: :any_skip_relocation, big_sur:       "4811043f10835f564f0a5a0ed0cddd54296bde326ef8009179f93f65f408ef16"
    sha256 cellar: :any_skip_relocation, catalina:      "ca82973edf5f625650a7d91233b79b78c72a5490e812539ed1dddabbd45da629"
    sha256 cellar: :any_skip_relocation, mojave:        "3888dedfff447099513ed51fe211df02fdd639b0ff6f5ace301748dc271da355"
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
