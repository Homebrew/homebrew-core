require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.8.0.tgz"
  sha256 "5ac710d1f3a86b8017727b99bc1dfad542503bde98f9167cb4c3bdf33d0885d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ded953453b42672b72e274357a2cc886c046e05adf330fa14c8e7fda405a3ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ded953453b42672b72e274357a2cc886c046e05adf330fa14c8e7fda405a3ba"
    sha256 cellar: :any_skip_relocation, monterey:       "f983b11bddbc84a00667d7eec59bdf24f9160afbf4b8cc935e65b1b40549354b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f983b11bddbc84a00667d7eec59bdf24f9160afbf4b8cc935e65b1b40549354b"
    sha256 cellar: :any_skip_relocation, catalina:       "f983b11bddbc84a00667d7eec59bdf24f9160afbf4b8cc935e65b1b40549354b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ded953453b42672b72e274357a2cc886c046e05adf330fa14c8e7fda405a3ba"
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
