require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.13.1.tgz"
  sha256 "89018a917b9c4e221e019ed719199743c37ac827e3a80c18997e923c35b67350"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bf71ff2c00e4bbde5f3602980d0fe64997d1d4d36ab7be32130f7fb34403b6af" => :catalina
    sha256 "dbfd2762138b08bd1da3bde3c01671a066a1a22e03d0d50d4710d2ab7eb4b1eb" => :mojave
    sha256 "e42751236a9a853b327da083afb0940cd934e041270b70568baf2f22711ff235" => :high_sierra
  end

  depends_on "node"

  uses_from_macos "expect" => :test

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
