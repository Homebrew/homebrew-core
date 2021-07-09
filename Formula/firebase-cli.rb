require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.16.0.tgz"
  sha256 "93177d8aba4109daf3628b03bf4adfa8f790015644e950dcdaea2c0b0e5963f5"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "06755d5246846d03fd4991882f1cf18b2d4751aa6451e746ae86f9fe77923a3a"
    sha256 cellar: :any_skip_relocation, big_sur:       "696b777ae7f30fa803aff011b7431e35d1baef59f9957f34c36504e17e92da25"
    sha256 cellar: :any_skip_relocation, catalina:      "696b777ae7f30fa803aff011b7431e35d1baef59f9957f34c36504e17e92da25"
    sha256 cellar: :any_skip_relocation, mojave:        "696b777ae7f30fa803aff011b7431e35d1baef59f9957f34c36504e17e92da25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7aa5b6cee862ff9c211dc350cadea1f2cbe1fd9e924ef7d025c945745304a07d"
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
