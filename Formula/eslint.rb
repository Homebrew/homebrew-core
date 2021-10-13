require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.0.0.tgz"
  sha256 "7d68c103198fb568a49ca1310c0c5ed728d18e0e8ed588999e4cfc54663fc834"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fdee6c4e7894d24c6f713f715a13b9af08bad45b46dc4de3e0523af1ab15a4e9"
    sha256 cellar: :any_skip_relocation, big_sur:       "1f67f84d88cba5a6c78edc8886a20c2d069d20feec1a696b573bcad6927b9079"
    sha256 cellar: :any_skip_relocation, catalina:      "1f67f84d88cba5a6c78edc8886a20c2d069d20feec1a696b573bcad6927b9079"
    sha256 cellar: :any_skip_relocation, mojave:        "1f67f84d88cba5a6c78edc8886a20c2d069d20feec1a696b573bcad6927b9079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdee6c4e7894d24c6f713f715a13b9af08bad45b46dc4de3e0523af1ab15a4e9"
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
