require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.17.5.tgz"
  sha256 "ed77a1dbe484966fa8475b071c96ebfd0a461d1a1a990dc014239aaa5562e87f"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "019552e6d9925966f6c3e654d72b2a710a4aacc1c939c7216b782f050da08fc8" => :high_sierra
    sha256 "b99b0b9b489c1b72ba3bc29ead0ce9aeed62029624e3d11a02244f7d14beb277" => :sierra
    sha256 "7baf5350cdde83a1dde85223795d81afd4e9748a62d6df3ba8fb4afd04a786d2" => :el_capitan
  end

  depends_on "node"

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
