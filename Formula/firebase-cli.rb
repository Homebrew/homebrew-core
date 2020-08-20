require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.8.0.tgz"
  sha256 "8d2aca5d433d50354dfb434b46e94dc5e9d9b10c4e3ab15dafb074b4106e6e7b"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "212968dc8b99443d4ca087328c54a5d46ab4c186ab811ca1342c70a6b96437e2" => :catalina
    sha256 "a532eef4fbaa6328caad09c5914d54018720485fc727aee451f449f84cadb0fb" => :mojave
    sha256 "fb18d27a7ccb2918068fdb10f0f20c59c5ff6a43e3cca03ec7f900455009a51b" => :high_sierra
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
