require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.11.0.tgz"
  sha256 "89518be1a496928abe4705816b275f74e82a2535fc07b950af0b8316c8e17237"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "ead0ac0ab31781902f3039e00cdf3fad6ee4349347489a2949debe805cc3d70c"
    sha256 cellar: :any_skip_relocation, big_sur:       "8e4bab73423f93b6f7ee998c2135cbfa019809039f85406455e35f653edfd191"
    sha256 cellar: :any_skip_relocation, catalina:      "8e4bab73423f93b6f7ee998c2135cbfa019809039f85406455e35f653edfd191"
    sha256 cellar: :any_skip_relocation, mojave:        "8e4bab73423f93b6f7ee998c2135cbfa019809039f85406455e35f653edfd191"
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
