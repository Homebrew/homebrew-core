require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.2.3.tgz"
  sha256 "e8724b65c0a76860a9e85a7e73a6f9d765cbab20b718d50f2fbb3a4d0fe80ea5"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "846a24a7a63ed6263731ca1baa8a95b2ed888657a14e4295001dbca81bdc75c9" => :mojave
    sha256 "af8c19d3b31a2ce40ff80e453405fa9432cb0eec9f3c4c17950be1accbf89109" => :high_sierra
    sha256 "8df6ff2e65401b90209328214a1a77e8d0d5d1614f3f8e50d938468acde83fbd" => :sierra
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
