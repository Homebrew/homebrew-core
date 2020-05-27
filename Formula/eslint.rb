require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.1.0.tgz"
  sha256 "ca47de8b5aad701f9adedf8bdf17e132904e9d118c8c4437e00cf2f753693a9f"

  bottle do
    cellar :any_skip_relocation
    sha256 "c053849de410a358f2e929aa6ea4d1480e39a60374d9560ba21f49ec79600c73" => :catalina
    sha256 "935d14c126f15e00b4dbf7e403aa88fa2badb0a55f6fedb8e91fba36b290f810" => :mojave
    sha256 "1782e208667a9c924a32667cb7f3e3ccc35912bbda6909134a6fd08851a8f46f" => :high_sierra
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
