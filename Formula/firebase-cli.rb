require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.9.0.tgz"
  sha256 "1afcfcbe60b0e76a474464b3afff53f6d93a3ede3e38d36b3916a1d1fddb7869"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e22cfca782e05c9009756f05fbd79620e2b6a74a06bb462caa6d225ae98d02d4" => :catalina
    sha256 "5226ee842c7336c8e89fa44b7825d53c16912bd514b10c14000fafe5956f121b" => :mojave
    sha256 "b46f8569cd88a50b4552fe998f7d89a413f0c549126736d02c535103cd8b61c5" => :high_sierra
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
