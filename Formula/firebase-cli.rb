require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.12.1.tgz"
  sha256 "b744fa014025d9fd12197399895f0e364383ef0505809903ac45896175e40b15"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b4761fb3d34d9e649715cfb6ff43630a77a4e22272d0fb1006a5a147688012a8" => :catalina
    sha256 "c5c2e646a8fc81feaf06c7d3cdc0d9f307aa3063d170cbfd84d7d4a0e73489dc" => :mojave
    sha256 "eb6951e1cf2c5f23a5a0ef1c1f3b555544181cdcdfecdff2241bbbecfddd256b" => :high_sierra
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
