require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.14.0.tgz"
  sha256 "cfdc51dffc6077ee0d19056cdcc6e9fcccab926bd13afc4ce0381308b2d30765"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ee2588a74b0c6b96f1e7d728f6ee18dcd3b55fa129dbe8a8f42356c3cdfccb07" => :big_sur
    sha256 "a1a28cac03cd4b64d7354ac06f60d913260b87b4ce945e10d0cc5fa97a81b787" => :catalina
    sha256 "0efb33b1ba8e57e7ec21ec72065ba9e3f2bc244864bff371ee7ed80d38e3229f" => :mojave
    sha256 "fc7f4bbc14eef82e697d94fd47aac3a768580237fdbd7c5bebdd8a8c128ebfaa" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".eslintrc.json").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")
    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end
