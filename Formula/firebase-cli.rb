require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.0.1.tgz"
  sha256 "d65dc9c232c5c0ba496600ae5d9c0b860cf75759e6b3755566c7f595497a53e3"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9f4a56f8bcd27952e47edd63ae266b67b79fb34b5605463eb94c3efc53a012d8" => :big_sur
    sha256 "6ef492f7e81905bfcb6b1e060a38869c8501ce7070d461b47026ac6634855564" => :catalina
    sha256 "4acc504cce5cda439cda116326d344e58a0a8cbafa1184bf7a30960946f51bdd" => :mojave
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
