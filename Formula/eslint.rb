require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.26.0.tgz"
  sha256 "4651982a6eee531671323ecf7981f30b1c635bb178f5fc3682feee5d8282ec44"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30de8887ea7c8726a6c923ff39687e6e3c82aa841cc5c5f5cc09f87670352bdf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30de8887ea7c8726a6c923ff39687e6e3c82aa841cc5c5f5cc09f87670352bdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30de8887ea7c8726a6c923ff39687e6e3c82aa841cc5c5f5cc09f87670352bdf"
    sha256 cellar: :any_skip_relocation, monterey:       "6cce5393d79bbd5ff611914701b0eae148867d599aae9070077ed76b5c628f03"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cce5393d79bbd5ff611914701b0eae148867d599aae9070077ed76b5c628f03"
    sha256 cellar: :any_skip_relocation, catalina:       "6cce5393d79bbd5ff611914701b0eae148867d599aae9070077ed76b5c628f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30de8887ea7c8726a6c923ff39687e6e3c82aa841cc5c5f5cc09f87670352bdf"
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
