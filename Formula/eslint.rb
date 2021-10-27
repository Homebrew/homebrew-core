require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.1.0.tgz"
  sha256 "d5bb1a422a273ba83a3453f5e1be76be893b55d94ea892a13c8c1c6af088c092"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e1bcbfc90f0a8f9a974903812df1612aca306ba9468f1202855750ecda85138"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e1bcbfc90f0a8f9a974903812df1612aca306ba9468f1202855750ecda85138"
    sha256 cellar: :any_skip_relocation, monterey:       "c2b835814fdbae577a88dea0594522c1179e6464c18c94f8d3cd81bb0f897b51"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2b835814fdbae577a88dea0594522c1179e6464c18c94f8d3cd81bb0f897b51"
    sha256 cellar: :any_skip_relocation, catalina:       "c2b835814fdbae577a88dea0594522c1179e6464c18c94f8d3cd81bb0f897b51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e1bcbfc90f0a8f9a974903812df1612aca306ba9468f1202855750ecda85138"
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
