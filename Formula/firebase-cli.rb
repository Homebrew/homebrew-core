require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.2.2.tgz"
  sha256 "a3ee99ca71e92742133d729dab02f6189e3e8d8f3610b1de5981c9a68cfd5db0"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "5d8e16314fb6aa45e027cd8c0c0280f3a4bf137a5e131685ec7583ec9ec26ccc" => :big_sur
    sha256 "b090d0fef2be6aac8ee44a5907ae5a591eb51ee1b570d5af451c46c8522b39ea" => :arm64_big_sur
    sha256 "e6cf937905f0721e5e9363ed81c4280ce66086c679441cf140f7afb67002a676" => :catalina
    sha256 "5c98ae7ea1fe5bf9108589f2877b03e9859d1815280136c836dcb5d87317ff53" => :mojave
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
