require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.4.0.tgz"
  sha256 "66aeab26193ddd26c43f879c1a7e3fe604479d5773c774daeede3c9f1b1a1995"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "73fdea0dc97af6fe31ea6473a0336dfcdf239fdbdee4d8cd657f5f4b5ea45cfe"
    sha256 cellar: :any_skip_relocation, big_sur:       "bda3718e8f678a881c33567e1707735e71bee5c8df2e941932383914b638d22e"
    sha256 cellar: :any_skip_relocation, catalina:      "8f1549346ae6d1b3319d9854369ad53ee12b67bd5eedd099a9fd7a7e41465bbb"
    sha256 cellar: :any_skip_relocation, mojave:        "a322f92f4effc4ad282f3f8cb09b559a225026bb2267b131e69669435756fb73"
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
