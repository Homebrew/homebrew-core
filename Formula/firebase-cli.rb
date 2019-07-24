require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.2.0.tgz"
  sha256 "dcd5721f21348032d510519194eb6a0a734b4915ac6d3a28a451ead9cce76e2b"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fbeee31e0b45787dc9e80ff296a4ec6e32bb97cb08b3cab680b41e6136ddd634" => :mojave
    sha256 "87c4b248bda309d76366bdc2f898c46c6b0746ab271066851180c12cd6fe4de3" => :high_sierra
    sha256 "6d43a357a142dbc274a7dd8d438ce9cef702406a5bdbcd05ad4327e9b57ee238" => :sierra
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
