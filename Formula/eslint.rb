require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.21.0.tgz"
  sha256 "836f2f203ce0fed92b40a606867a2c8b1f3abc1cceb6cdcb0151d9ef8601997f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ddd4334d3fc644d516a7fbf928d9defced090614b03f83843216b42932cc60eb"
    sha256 cellar: :any_skip_relocation, big_sur:       "0ba57433e709c0e2d9995f42d57fc40f972c2e5744be848e9893d984b14c19da"
    sha256 cellar: :any_skip_relocation, catalina:      "c94b5df524fd966de5abfaa0ad729f412dd9c3a476a2127a47245e4eb7d0d6c8"
    sha256 cellar: :any_skip_relocation, mojave:        "5367c9bc642495e655e32b1c40e73d5cec52477f9858006b765fb88b5f9bd56f"
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
