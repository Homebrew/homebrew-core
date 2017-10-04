require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.13.0.tgz"
  sha256 "41df772ec0b3db088dd285f5853cd8289ee714d8a8b040ea47803f9ac33eaefd"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "053e60f3a2b0da613835f98c80ef9fc781078e7dbab0be470264c80c9417e31a" => :high_sierra
    sha256 "582bb25ea4d7fbbde42ffb0282dd40ade2157c23de612546f049071bd0be7277" => :sierra
    sha256 "6c25c041eccffb7459fe141c354574a9d11993b007aa528a384fa055c70e03d7" => :el_capitan
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
