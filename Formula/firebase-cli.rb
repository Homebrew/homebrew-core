require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.6.0.tgz"
  sha256 "be945e2ef269577fbd41fa2f95ae0e3185837b54e9190e28ce4ecd3d9069993b"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "b673e5eb14d80c0c36f9e0e940871de96ae87d4a4ed5a8d37886bfebb7ad8481"
    sha256 cellar: :any_skip_relocation, big_sur:       "7a96fd7b000f3a92dba2989a4242ceac8fa07f55162baf1d9e95f98c587e50b6"
    sha256 cellar: :any_skip_relocation, catalina:      "210faa4d195ffca5f0935bbad1d018d2df7850d81a27e6ee6e593e08839d6779"
    sha256 cellar: :any_skip_relocation, mojave:        "eb9b09e8a9101502b6647a945a9e782f24bd2fbd4e2867a12ed2572c040ebb29"
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
