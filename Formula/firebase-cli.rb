require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.17.1.tgz"
  sha256 "d43111a522553f9fe9f78e82cc7a999dca3801002eda27ecc2044f1d84fd3333"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "76973009ddb9e387e9fbfda414ea2a0e243029a699c4b6b6759ddd7c55c340b6" => :high_sierra
    sha256 "a6892d4a558c7a173ba2b84c2458f2a3130c0e45d09db57e4f15c3e7bce84a15" => :sierra
    sha256 "d0a98d8ee859d704f9d9aa0b96f6b71aef75c148f6c9c774be6bf9029857ee66" => :el_capitan
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
