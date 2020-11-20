require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.16.2.tgz"
  sha256 "c3c7fd30ee57ab1997a55ac63d4d867469d7f663dad778cd469fb7175c422f42"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1c9c1b2c285e750368e27d6717e7e767de6943f97820c3125dcab7d69105dfb0" => :big_sur
    sha256 "64fb5ac517d004cdc4f7296ba16ce9ed9cc595aa814eed995323d24a97c5523b" => :catalina
    sha256 "9549bfbe548cae8102d0fcf5fd2737a478dbf23004426c561f91ff4ad20e30ed" => :mojave
    sha256 "b9bf5fc81b1b9858c7fb61fd1a7ca77c148d614e38bdeaa048458b65993fac9c" => :high_sierra
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
