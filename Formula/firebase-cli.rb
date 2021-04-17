require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.10.0.tgz"
  sha256 "4c9a2999f8a75bc3fb5eb95555f9b5719fe61b46763eb27a0b3ca5a38ada60d1"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "9e191c1b1b9537fee1b5980f569e8e1c40e71757057934c10986a64c985fbe0c"
    sha256 cellar: :any_skip_relocation, big_sur:       "56fc6a16721b505bed1e546dbc35c580e2f640ecbf9c66618a62a7e6110653d9"
    sha256 cellar: :any_skip_relocation, catalina:      "f26347fe19cf36ae4e3b6f13c86856efbe67def7891f0353e62fc6d8f59f39d3"
    sha256 cellar: :any_skip_relocation, mojave:        "54cc34586619c83f74e63467699ec64fd76ad379dff6f21fb14fcc2d558ec640"
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
