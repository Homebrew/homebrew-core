require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.2.1.tgz"
  sha256 "0a34dd7cfbad17c3357f20f52a2a48575a6f636826fd1a4622876a790a426929"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "67eb3398812d7e5c8ea0f240503b3654ab2d83ba062ebea37783e772814b4eeb" => :mojave
    sha256 "72910e37e8d0c637a9ff87317340e28fca90d008d8f52aa0fa37666442717eab" => :high_sierra
    sha256 "70a21a1e98d0f54c967822d6f0bf280b0b3cd8b49a9690a1e424bf37c4bed773" => :sierra
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
