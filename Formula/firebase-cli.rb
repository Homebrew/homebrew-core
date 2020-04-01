require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.0.0.tgz"
  sha256 "a44a2884e6210b50486146dfaed35fde75d09d14920fbaa63d27ae2707197a09"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd12b17f5b174d9a56c6e1d5bd9ea731cd13d51ea726a63ef271dfab72985746" => :catalina
    sha256 "4ebd2b90fac08ad83748dded74cafa884f41af20ffc1df19655150bb0e3a4c45" => :mojave
    sha256 "0588b785074d2ac6fc7cf3e0f4e5a08d822829df5571009a114be83df6bbc2bb" => :high_sierra
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
