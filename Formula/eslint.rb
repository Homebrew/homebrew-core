require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.11.0.tgz"
  sha256 "8be9af064cd87d3e7e6700b86e61883c8b9ca1eb0b3cc4fd8825017ec57314f7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65f7957e44e92f6b8b418099238f640f829597a7854e0e351b0bec8044ab138a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65f7957e44e92f6b8b418099238f640f829597a7854e0e351b0bec8044ab138a"
    sha256 cellar: :any_skip_relocation, monterey:       "8efc3e39f353186b059b9e97c6c88aa9f59397b122c4973d57408547ab49c149"
    sha256 cellar: :any_skip_relocation, big_sur:        "8efc3e39f353186b059b9e97c6c88aa9f59397b122c4973d57408547ab49c149"
    sha256 cellar: :any_skip_relocation, catalina:       "8efc3e39f353186b059b9e97c6c88aa9f59397b122c4973d57408547ab49c149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65f7957e44e92f6b8b418099238f640f829597a7854e0e351b0bec8044ab138a"
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
