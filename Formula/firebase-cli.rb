require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.18.3.tgz"
  sha256 "84b933922771686a207f34b9db5415bc709ae520b5f070d1f0eb4c002d7f0291"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9b7085eea69624a747b33d7174fb9226ec18a6ee846a4b3248973b988bbfb09" => :high_sierra
    sha256 "4344d82fe09729d68e45b96de4241a1f5b41e577bd5c0287e94a229d46354ddb" => :sierra
    sha256 "1e4c3fff056c2a3568027ca3c6b65b8d6f3ec40dae014931ae4df0b78e5b0442" => :el_capitan
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
