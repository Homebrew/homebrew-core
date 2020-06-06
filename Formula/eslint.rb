require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.2.0.tgz"
  sha256 "09285faecb9ae44d568c432ec6ed68fe625d0b02e2b1b3eec60d8d140ab2f4e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "5bc8c7f29aaf56f12c6365bebf799b767a21d8679b74df2b3aa18513b45731c9" => :catalina
    sha256 "93a43433a915d27fd34b79e5a3768b0ed8f3a0f0cd302cc0be288b527e2c0f0a" => :mojave
    sha256 "13a3098515289ae434a6ebde0d5b5cb6e3973ecfe04333a8bb15deb471481189" => :high_sierra
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
