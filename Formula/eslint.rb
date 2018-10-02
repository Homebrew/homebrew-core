require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-5.6.1.tgz"
  sha256 "eab6da769bcdc0774e2dd89795ca3d3568d8383336ae52ee9594cc1c503d1d91"

  bottle do
    cellar :any_skip_relocation
    sha256 "693a14760d191425e88f031ed4ae2da8cd3e3ca632d5df6bc904aacfdd0f8a9d" => :mojave
    sha256 "19aacea3fb612b7bdab5cc4b020c80fc9825c1102b017ca144bd6de10227648c" => :high_sierra
    sha256 "386861febe05f447340af37189d90f835d3b42a708d34ecd81445df1867e222c" => :sierra
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
