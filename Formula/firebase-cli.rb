require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.3.1.tgz"
  sha256 "6bccc7bed1f8ae28d53932f1850d7cf1fe62f4bdc5ac53ecfb97a1b366233562"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f459694b05c8ea6ce5a55c1c8e3ba26f25d0664e020dafd2de00a5af78e23d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f459694b05c8ea6ce5a55c1c8e3ba26f25d0664e020dafd2de00a5af78e23d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f459694b05c8ea6ce5a55c1c8e3ba26f25d0664e020dafd2de00a5af78e23d6"
    sha256 cellar: :any_skip_relocation, ventura:        "0b3cf224cca9968f1f4c0d96b568369158c0fb81aca1c20532b8236eb51d73de"
    sha256 cellar: :any_skip_relocation, monterey:       "0b3cf224cca9968f1f4c0d96b568369158c0fb81aca1c20532b8236eb51d73de"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b3cf224cca9968f1f4c0d96b568369158c0fb81aca1c20532b8236eb51d73de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f8e1b633c54b7cd5912d2d5f24dfca5ee75d81c3ea2c1fc933e5280c9bb8efa"
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
