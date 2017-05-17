require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.8.0.tgz"
  sha256 "e84ad7b6af68464e42bdbd3c2430e551f57e31fda6b48618284c3e0ebae2ffc1"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb13655a0174499ecbda4abe66676f5f00cca5e7e662240953aaeadfe198198c" => :sierra
    sha256 "c0c6d20d9b0520c6ca4997538842331ef4f0cd782ac10e5c27d1b92ba1a272cc" => :el_capitan
    sha256 "f42b538b57167d123a46902f786b6d3954dd318cb796e0270c33ef6f6ed68d49" => :yosemite
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
