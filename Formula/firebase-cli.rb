require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.5.0.tgz"
  sha256 "bcb2278313a2a8db873e5e402b8531bfd90ef7dbf9ff591205468d127ca41e4b"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "be3733c0b37f9d7b7571959b662f55f954a1a21ea11f8c183da20a3cdf2b8bba" => :catalina
    sha256 "e8dc82a70348450fb17c9050b0289c95439f1dcdd7de42b23b43a9da3d8b0c0e" => :mojave
    sha256 "b78b6b7995ac52408d2b2510e18e145b82a474760fd0232094c14385b801c776" => :high_sierra
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
