require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.48.0.tgz"
  sha256 "ea829ac4fa6541fdedff8485f2b1be849f8c0fdc6a48e2b28293dfb9e6d664ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "603a4858f98e351a8fadbb09ae27b92c781d47a380df48d353506d8797dee558"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "603a4858f98e351a8fadbb09ae27b92c781d47a380df48d353506d8797dee558"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "603a4858f98e351a8fadbb09ae27b92c781d47a380df48d353506d8797dee558"
    sha256 cellar: :any_skip_relocation, ventura:        "a414e511bc0ad8b622aeb3829c31dc1d4a626352d2b4e7d9fd08ad031e890252"
    sha256 cellar: :any_skip_relocation, monterey:       "a414e511bc0ad8b622aeb3829c31dc1d4a626352d2b4e7d9fd08ad031e890252"
    sha256 cellar: :any_skip_relocation, big_sur:        "a414e511bc0ad8b622aeb3829c31dc1d4a626352d2b4e7d9fd08ad031e890252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "603a4858f98e351a8fadbb09ae27b92c781d47a380df48d353506d8797dee558"
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
