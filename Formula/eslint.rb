require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.3.0.tgz"
  sha256 "c82ba7a1bff44b2e250811b4b60a8f5fd0fa6ec689744d03733f7d60e8fea693"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e85f5f9d02fed3187b6a7ec87746d93c36478f4053460203c6d38a913954e269"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e85f5f9d02fed3187b6a7ec87746d93c36478f4053460203c6d38a913954e269"
    sha256 cellar: :any_skip_relocation, monterey:       "539292435aeedaa976e63ab91cbd10c5b0fde3d029d0cf1948697a52be628eb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "539292435aeedaa976e63ab91cbd10c5b0fde3d029d0cf1948697a52be628eb6"
    sha256 cellar: :any_skip_relocation, catalina:       "539292435aeedaa976e63ab91cbd10c5b0fde3d029d0cf1948697a52be628eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e85f5f9d02fed3187b6a7ec87746d93c36478f4053460203c6d38a913954e269"
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
