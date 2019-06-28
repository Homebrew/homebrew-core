require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.0.2.tgz"
  sha256 "9314257cf86d265faa8c56b44e3d221fd9f96d36568fb30dd5e613c55d30404e"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "4588ef191a6905c12a55aea6cb7314ddab3206037070a08d001e15919653d2a3" => :mojave
    sha256 "4ec8b476521d2f42d25aef44ae135f64e26f2c6eb582fc4bb2791bbe73ed62d0" => :high_sierra
    sha256 "8cc86abad4748f324570513d565080b0927f891ee66b3b551d9c1a1c4808dcab" => :sierra
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
