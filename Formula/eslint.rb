require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.3.1.tgz"
  sha256 "6e8b7d945b7378e444d983da4ff7b867f3f1eb849f46f0cdf632517db93758b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "5fbd1403538425756c749e802c15fc1e0451a3cbaf6909d2dbe0a877eb09ff09" => :catalina
    sha256 "9b3c4b0553e417832882e0e3714f39c655a650b999a977708885cd209cc33f30" => :mojave
    sha256 "a539ceece09a404ccf42d2c4c435e5e57a94f75d9eb075ddb61fb62d389718f8" => :high_sierra
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
