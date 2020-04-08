require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.0.2.tgz"
  sha256 "446c7ade85333293c9d6de7aee9f13ad3004065eb2d8c2e9ee7a32b03bf59f10"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d95f86c54c8abecb71a51b8629f091209c1f4084f2374231832db7d9b6a4671d" => :catalina
    sha256 "2c05528b0732ba83448294c2546d99fe49db39073fbf27824dbca60cb8e37cce" => :mojave
    sha256 "caf5820e83b4c33be9e4d8ed076b6a8f748c9c0da755c7729b9aadaccaddb0b2" => :high_sierra
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
