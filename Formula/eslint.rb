require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-6.3.0.tgz"
  sha256 "1933b81983d4348b7acf6c5ab756aa412b68504bc3c4aac929ea78e8b215e7f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "28773173de1688b4fa11adb66f5e2fb62f237b11ef78b9753c3cce338ed8a6c4" => :mojave
    sha256 "b17a91d82517b63207ce74e03f068214cc0261f85de9503dd0b9949b83c0631c" => :high_sierra
    sha256 "b9282c1ba8eff409535f86e932e3a0e364800760648949d3730d46905fd354f8" => :sierra
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
