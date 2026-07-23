class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-10.7.0.tgz"
  sha256 "e515c437bb6301d34880dd69d3b42337095f9bc629edb1b92b42f4e83055eea4"
  license "MIT"
  head "https://github.com/eslint/eslint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "377ca07ff9989168af18778c0e3b93847a378c218e9b654f4842c9ce20e60b9f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # https://eslint.org/docs/latest/use/configure/configuration-files#configuration-file
    (testpath/"eslint.config.js").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")

    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end
