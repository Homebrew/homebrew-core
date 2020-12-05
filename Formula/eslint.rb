require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.15.0.tgz"
  sha256 "8a8e220eaafbdc23f0e91baad1b492f736c17e731502a1eda9a2f5a8026d4c7b"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5014c61a8ef3bd593783e6650d1a348b9217b6cb9cec031dda9d0d925bcb3be5" => :big_sur
    sha256 "38a6b74edd765ae26d7137ae6ebb6ef3c7be1a9e6eef7afba6baa26126b2a99a" => :catalina
    sha256 "2108f454020c57fda310de6cfe45d47207d3248bc2dfba481703a835b1913ed3" => :mojave
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
