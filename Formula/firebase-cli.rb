require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-6.10.0.tgz"
  sha256 "19b13391241d977df38ee61ff5860eb77d1a6421a994df87c65f939497c12371"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "f4b724f4b3e3adc52b5a47174f4f31594eb841e29970af5e4f7724afb49878bc" => :mojave
    sha256 "e7469b8d42ef769babac762b718c95fdaffe583a28c737a7efb437a03f200ded" => :high_sierra
    sha256 "5e2c9f6be493b66ccdbbcac9173c02d8c6a87aa10a5e8b56a37ce19027cdc48e" => :sierra
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
