require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.5.0.tgz"
  sha256 "52b1af5c415c26ff7b458987515fed2d888744490dc97db1fdd23559e6368138"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8d57f10a0580157059596ef75b1c0fa8f24afe85d7ddad2eabf284cf724c1d9" => :catalina
    sha256 "04383ff698cede0646f366906ec93675358ee1cefc56e6cab5751bfaa49e338d" => :mojave
    sha256 "46d6ed296b0b8f30c79b9f524c077e6bb96fcdf2e8d0a6ce8944ae74a0d9930f" => :high_sierra
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
