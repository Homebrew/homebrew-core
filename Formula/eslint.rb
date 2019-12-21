require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-6.8.0.tgz"
  sha256 "10da0d30a69d0ac0b6ea690fdd1e5dd8edf61b5a5f1433d99f976452067947b8"

  bottle do
    cellar :any_skip_relocation
    sha256 "1dc4ac0aa7322c1899a889afa30dfcf33e87580e4b32b7533edf412b8c4329db" => :catalina
    sha256 "8e00c32063c29600fe017fc0315ecd3ccf4b16e27ece2c79008c702d4d980568" => :mojave
    sha256 "dd8eb47f6fde623f8caa003357cf7035cdf4de6eeb4443c72b20e3e13b738288" => :high_sierra
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
