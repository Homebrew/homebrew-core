require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.2.0.tgz"
  sha256 "4429a53519bcca5a5d56ee41ee47dc0f71e5a698b4c3b5881fbe266c2c9177f1"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e78383534ceb269422733ac9538c8b4096dd6fecab0dc0c33b2fc681aa6627c3" => :big_sur
    sha256 "c814df23fa8387430066e01a14e93bf568319f77f345e6704b8a6e92a3efbc2d" => :catalina
    sha256 "5c3858aa69b15b271cf5f3c804ae8502414670cd080f1c7870cf95af3f4171ab" => :mojave
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
