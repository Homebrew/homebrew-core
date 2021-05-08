require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.26.0.tgz"
  sha256 "7df1293cce22e076980b9aba48d1521a4ff3edab093b60a0547eb586ccebe4f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3a44685d598ebccb7f4f5e7f8cb6bec32184a59937747cb2c07e350df6892fbe"
    sha256 cellar: :any_skip_relocation, big_sur:       "fe18418dd1a396a3fe390e5cd44d4de21f0bf008a924359b254c8b98f35a2575"
    sha256 cellar: :any_skip_relocation, catalina:      "fe18418dd1a396a3fe390e5cd44d4de21f0bf008a924359b254c8b98f35a2575"
    sha256 cellar: :any_skip_relocation, mojave:        "fe18418dd1a396a3fe390e5cd44d4de21f0bf008a924359b254c8b98f35a2575"
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
