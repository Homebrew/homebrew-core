require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.22.0.tgz"
  sha256 "94bf1c54b0cebb75d12f2bed8b12042e414699699edc3550c82b95b8b155eea1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f90cc9318cdf352ba3aed444e4191c8f9f3f329ae4acd77415c82a7f148074d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f90cc9318cdf352ba3aed444e4191c8f9f3f329ae4acd77415c82a7f148074d0"
    sha256 cellar: :any_skip_relocation, monterey:       "ae3798493213e770f2c6427db3fa14a3127b0893661f383a60de6b9a300ae639"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae3798493213e770f2c6427db3fa14a3127b0893661f383a60de6b9a300ae639"
    sha256 cellar: :any_skip_relocation, catalina:       "ae3798493213e770f2c6427db3fa14a3127b0893661f383a60de6b9a300ae639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f90cc9318cdf352ba3aed444e4191c8f9f3f329ae4acd77415c82a7f148074d0"
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
