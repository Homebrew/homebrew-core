require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-6.4.0.tgz"
  sha256 "8fa288f0a400269f9128cc037ebf68f516ee7271fdb9435bbe0919bbb4378378"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d1048f1c10a32a683d1744b9e32bd47ca04751ef29eb114de390badc08994ff" => :mojave
    sha256 "17a711423dd0795fe71d55018cbbf8ef4a286f5dfcfdc40dd296147b792d9910" => :high_sierra
    sha256 "543204880092c6b8d39a4b76d093ec8d42ae69d7379158efbb7cdfc6de47ee88" => :sierra
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
