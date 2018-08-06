require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-4.0.2.tgz"
  sha256 "348d5b8173b52633fdae19e305fb0c88cae01ac5908aa31549d023daf17aa003"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1963417005c0b18ac854f62b56a0f1e0f1345c91f33741b941af05bf4dbd6ddf" => :high_sierra
    sha256 "5a31114c10fef28c94eb4cadfa7049b50de8cc247537c46355ab7253a95345ff" => :sierra
    sha256 "af9c43480cab0530955e330319e6a8c53359ee710defdb23aa8ce3ecac9a4595" => :el_capitan
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
