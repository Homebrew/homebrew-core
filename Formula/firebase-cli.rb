require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.16.2.tgz"
  sha256 "40a33e737ce467c3a761f6a056fcf408db1632a6bbd503228ef2cf5470d1ed72"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a21980b4924e5ae363826ac6c62f7bad89be356d84ffed747cec9b30650c6b31" => :catalina
    sha256 "451a53146d660823072b6e052360a814b6f4fc2551a4e6666ec214e44cab584a" => :mojave
    sha256 "7c7344cfabd2987f284e50b9e2c4aa487ecb247c1ee900d3a835972cccb9aca7" => :high_sierra
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
