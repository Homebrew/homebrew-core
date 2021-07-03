require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.30.0.tgz"
  sha256 "63175a8581fa4ad2d28fe375f086b61066f30facabff83d0f76a4f8928455456"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "39b2dcc553b96e6c675afb1388d49950cd19cf7b38f53848eb2a8d8a0210e9a5"
    sha256 cellar: :any_skip_relocation, big_sur:       "9a6747bf1b02c79f6a336e9c7dfd398a0885eb3bacd976aa554b11bd764c161e"
    sha256 cellar: :any_skip_relocation, catalina:      "9a6747bf1b02c79f6a336e9c7dfd398a0885eb3bacd976aa554b11bd764c161e"
    sha256 cellar: :any_skip_relocation, mojave:        "9a6747bf1b02c79f6a336e9c7dfd398a0885eb3bacd976aa554b11bd764c161e"
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
