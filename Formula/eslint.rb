require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.31.0.tgz"
  sha256 "3b121b757bba6000caa24fe22471e3dc2cfe3cfa83fd3e17abc0c6fb4b0b4b87"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcede2405aba54bd51786b37b3fcc8e8196c6944b0f0475013d9c7d405424cd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcede2405aba54bd51786b37b3fcc8e8196c6944b0f0475013d9c7d405424cd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcede2405aba54bd51786b37b3fcc8e8196c6944b0f0475013d9c7d405424cd7"
    sha256 cellar: :any_skip_relocation, ventura:        "ecd39efc4dbffb10ebd2508a8eceb84e97d7d546219fdf594616bb1efa5d2656"
    sha256 cellar: :any_skip_relocation, monterey:       "ecd39efc4dbffb10ebd2508a8eceb84e97d7d546219fdf594616bb1efa5d2656"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecd39efc4dbffb10ebd2508a8eceb84e97d7d546219fdf594616bb1efa5d2656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcede2405aba54bd51786b37b3fcc8e8196c6944b0f0475013d9c7d405424cd7"
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
