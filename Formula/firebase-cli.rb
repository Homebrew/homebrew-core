require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.15.2.tgz"
  sha256 "b9c4506f75b3150d1c54d707ed620a7b5d5a5f144e45daaded5182e88a58ce8b"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "b2f41709deac7c3bcf141e06e178f5ec53be62a5ba5b020c9f4d5b37cecf5e1f" => :high_sierra
    sha256 "f2c2af783cc8febe4cc2a8f932b386d642c9284177911d9cbcfdaceced01beff" => :sierra
    sha256 "a2e187c00eede939463ab9dcac16b52982d0f0821ff30f9c6c358659eb702275" => :el_capitan
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
