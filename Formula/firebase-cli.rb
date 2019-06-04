require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-6.10.0.tgz"
  sha256 "19b13391241d977df38ee61ff5860eb77d1a6421a994df87c65f939497c12371"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "26044961963d1e261f1028e103dfc83bb00c855232064f2c486255edac047ef2" => :mojave
    sha256 "3ac3f5a36b7daa349cbfef83769b0f289d9fb2afa47fa19596f158ded4b9c1bf" => :high_sierra
    sha256 "b2baf086b006699ea2458280bb67f7a67c2d378f3145fb37c1513446f7d30aa6" => :sierra
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
