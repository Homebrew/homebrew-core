require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.19.1.tgz"
  sha256 "0d39a4971b7da3a3b5f06199e28c2ec4ad8baea5c8bbdc247b8f3ae4bc47d534"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee1a8f62b8e00c33528c0d183b5ad4ef2321558bbb2f96dd0a7f1f95bdb87412" => :high_sierra
    sha256 "68f034ca69694b5fb833db9a7792e3795ca29590d95b8de512de67ad48ba9ae3" => :sierra
    sha256 "a0bc4976d07a49dc3de8b9761566b63beb9470a0bc2b70b52b3056d37595547e" => :el_capitan
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
