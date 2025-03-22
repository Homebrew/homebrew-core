class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.23.0.tgz"
  sha256 "313e4ac4a9a685fbf12a29b5c18c78eaa697f855517e32e3cd122141f89ddc9a"
  license "MIT"
  head "https://github.com/eslint/eslint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78a1ae1aee874d99c3315571e233c14360e592e78cefbd828f5d2bda2c615884"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78a1ae1aee874d99c3315571e233c14360e592e78cefbd828f5d2bda2c615884"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78a1ae1aee874d99c3315571e233c14360e592e78cefbd828f5d2bda2c615884"
    sha256 cellar: :any_skip_relocation, sonoma:        "1228c13075cdbe1731ea84d2609cf680bf3aa6342392980679fa69a8f31d955d"
    sha256 cellar: :any_skip_relocation, ventura:       "1228c13075cdbe1731ea84d2609cf680bf3aa6342392980679fa69a8f31d955d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78a1ae1aee874d99c3315571e233c14360e592e78cefbd828f5d2bda2c615884"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78a1ae1aee874d99c3315571e233c14360e592e78cefbd828f5d2bda2c615884"
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
