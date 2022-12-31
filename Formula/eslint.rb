require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.31.0.tgz"
  sha256 "3b121b757bba6000caa24fe22471e3dc2cfe3cfa83fd3e17abc0c6fb4b0b4b87"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1100dfb6405178568119555c5bcf2a6e2a6efd273b762583d87ff9d301be2ab4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1100dfb6405178568119555c5bcf2a6e2a6efd273b762583d87ff9d301be2ab4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1100dfb6405178568119555c5bcf2a6e2a6efd273b762583d87ff9d301be2ab4"
    sha256 cellar: :any_skip_relocation, ventura:        "2d4bee0950a4c8702cefb94d7d24bd6da54f771a948a4066b684c8462685ff6f"
    sha256 cellar: :any_skip_relocation, monterey:       "2d4bee0950a4c8702cefb94d7d24bd6da54f771a948a4066b684c8462685ff6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d4bee0950a4c8702cefb94d7d24bd6da54f771a948a4066b684c8462685ff6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1100dfb6405178568119555c5bcf2a6e2a6efd273b762583d87ff9d301be2ab4"
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
