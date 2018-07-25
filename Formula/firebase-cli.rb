require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-4.0.0.tgz"
  sha256 "4b0eff67c293737fde887d0c3334e4ad1f9d926b7a03cf1f526e232f16c55a76"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fac29d6dfae75b07de98032017f0015d13577ab5395e1c3295345848c6b648eb" => :high_sierra
    sha256 "95f226de97f3ff195053ad0b66dc850b99bd8abe8ecfc9acc20888a040a67108" => :sierra
    sha256 "48fdc1ed7377da592ad1b76052256db41fca542e3ec2e98cc449293e389a0755" => :el_capitan
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
