require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.8.0.tgz"
  sha256 "e84ad7b6af68464e42bdbd3c2430e551f57e31fda6b48618284c3e0ebae2ffc1"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c996479b8238a409e3aa7a56a9ce44ad9171b36f9f3a390bd4cb822d50706fb" => :sierra
    sha256 "12380e80e4d79089aade13349782ea0249c6089bbc83e84a0c614f5d33a86e7e" => :el_capitan
    sha256 "cf5e8075e8e2b89cc5bddb88ee9a2d39acfc0e45019dc8fbab3f484372ad65cd" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<-EOS.undent
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end
