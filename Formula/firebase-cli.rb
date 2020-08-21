require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.9.0.tgz"
  sha256 "544070dbd2955a3613d7f0c5a05cc1088b144ddef2776a893244c3d194871c2b"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4df5a84bb6aff9199f91594ba878094643be5678ee45ac0989e57cc2869d7a30" => :catalina
    sha256 "764194a96e7232ad2e72035b1ce69bb9d22346c89f5490c1fe8eff6c2b3e18d5" => :mojave
    sha256 "093fd1223d60e16357cd3fb8955f1c8c8d4a032d9d54dbf25255e2c94dae56b6" => :high_sierra
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
