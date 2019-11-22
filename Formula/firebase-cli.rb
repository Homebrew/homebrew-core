require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.8.1.tgz"
  sha256 "76cf2d485de8a83294daa8e24568df9b3749a71c81429544ce55dc14aae5dfc2"
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
