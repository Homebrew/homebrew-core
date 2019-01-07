require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-5.12.0.tgz"
  sha256 "adecf09905587e7fbcce6d1b735edb747a7c163de8670081e2764a2248fb2441"

  bottle do
    cellar :any_skip_relocation
    sha256 "74c2e5a6b80fb52bf292fe12935ac1cafd10799fc364e066d1872355ae02bf68" => :mojave
    sha256 "32524352364966cc59f0c22be6ed72b114188cebe235baba1779ece212e16802" => :high_sierra
    sha256 "43df2e062f0463099568760a2d29482fe261fc5ad900455ec4dd2635adfcb376" => :sierra
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
