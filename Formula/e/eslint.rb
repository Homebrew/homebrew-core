require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.50.0.tgz"
  sha256 "5dae53ebb06ca7b71ff0f756d78f3a0fce873f5ea908d24e348e2d2341fc6b98"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9cb65dd976dd6a885943cc427aba3989268497bc40cd9f62f6e0f68f668aeae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9cb65dd976dd6a885943cc427aba3989268497bc40cd9f62f6e0f68f668aeae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9cb65dd976dd6a885943cc427aba3989268497bc40cd9f62f6e0f68f668aeae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9cb65dd976dd6a885943cc427aba3989268497bc40cd9f62f6e0f68f668aeae"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f39115d127f86b5bf98ebed0e2f35af90ff95d6b103ff1a70f4757e6df0143b"
    sha256 cellar: :any_skip_relocation, ventura:        "1f39115d127f86b5bf98ebed0e2f35af90ff95d6b103ff1a70f4757e6df0143b"
    sha256 cellar: :any_skip_relocation, monterey:       "1f39115d127f86b5bf98ebed0e2f35af90ff95d6b103ff1a70f4757e6df0143b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f39115d127f86b5bf98ebed0e2f35af90ff95d6b103ff1a70f4757e6df0143b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9cb65dd976dd6a885943cc427aba3989268497bc40cd9f62f6e0f68f668aeae"
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
