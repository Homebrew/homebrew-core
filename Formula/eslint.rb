require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-6.2.2.tgz"
  sha256 "d8828ce378eb28f4d92c3fd28511cb371690a733570ef973542b534d2407db29"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba71e3b85473cee8593e67cfa7fd0e842cb2e90f90ffc72a4f595e61fe401c6d" => :mojave
    sha256 "5af59da3c56803f8b92fc5ddbc4f468b33466956d7425b203128770c988e2a4c" => :high_sierra
    sha256 "47b1860a21374a8297b4f8e799c5f3d12eb0f94ade0b528227c0cafc86011d29" => :sierra
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
