require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.0.2.tgz"
  sha256 "9314257cf86d265faa8c56b44e3d221fd9f96d36568fb30dd5e613c55d30404e"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "45da2c7c35669d7674dd7a920f33d4244d28de79b557ae86361072160957fe62" => :mojave
    sha256 "a12f88e8f071cae4ab83f81fe3f928bcc4ac68f415b4aa6142b28d7357d4a235" => :high_sierra
    sha256 "9c8cfcd388f5f49d1e30f6e86cadede51f182b02f023af64755113d9e070d9f9" => :sierra
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
