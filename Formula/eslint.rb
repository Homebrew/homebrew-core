require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.20.0.tgz"
  sha256 "849beae88b014ffb2d3b84bb53da50a9d9fdf54272731f4c3d9b805c9f200ca2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9ef72e25b5daf922c348c6e437efd9f2ef5866fcf28342961dbf811962052543"
    sha256 cellar: :any_skip_relocation, big_sur:       "c9cfb9014a6b044df87cc89c9370a077441a43e2092bf368b7745a02043c17d2"
    sha256 cellar: :any_skip_relocation, catalina:      "99f54a0c544d7e390d186d814efdaf6b2482256d052689b1974d071663ff00fb"
    sha256 cellar: :any_skip_relocation, mojave:        "2328d20d96eb3ad548542bae09ec10ea8bcd0d2761826e4cf52969f32342e133"
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
