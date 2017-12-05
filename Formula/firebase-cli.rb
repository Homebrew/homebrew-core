require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.16.0.tgz"
  sha256 "d1d466497eaaaf9729c2128b7ba1d27a51165cfe9728fa311e7c259ca5acbd01"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "b7b6e60404f1903f299be9e41815aea0f09c0cf6ce7b08b6a0a5144fa148f1e7" => :high_sierra
    sha256 "5e98fe687b4763aa474bd0e4646f715811dbd50faddde0cc48fde5192e7325e2" => :sierra
    sha256 "99a9ef1f89d68a84cd279c14eca7df9fd77d710f637c441a80dcc228d0620942" => :el_capitan
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
