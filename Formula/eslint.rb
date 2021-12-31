require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.6.0.tgz"
  sha256 "ca47edc46dd95316882d457ee782e47b4c7bf5e3c095c8d98a44ccac63974d39"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b45c0ed251a0a0d5f49b2e27b15844eda00a5ced5b52d039042a8a49f250fc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b45c0ed251a0a0d5f49b2e27b15844eda00a5ced5b52d039042a8a49f250fc9"
    sha256 cellar: :any_skip_relocation, monterey:       "8092a4718813868844fc30cd8f82d4222904480722099ae9e5e4496acdb1d1d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "8092a4718813868844fc30cd8f82d4222904480722099ae9e5e4496acdb1d1d2"
    sha256 cellar: :any_skip_relocation, catalina:       "8092a4718813868844fc30cd8f82d4222904480722099ae9e5e4496acdb1d1d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b45c0ed251a0a0d5f49b2e27b15844eda00a5ced5b52d039042a8a49f250fc9"
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
