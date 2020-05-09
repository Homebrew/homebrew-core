require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.0.0.tgz"
  sha256 "a99b1c56f1577a67ac4de68f66088deec90a332373cfd2a9adf445e60f91cbdf"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e430486d7cba6dde572a89c77784d48ece9ae6ed18b9294d9d4f6288554a24e" => :catalina
    sha256 "b868f7dc4fa0faa6cf5525ba9c53a7c44ce86f0ea445e4499242c778f608f3a9" => :mojave
    sha256 "1cf90e57b38857aae6e8d03e7e7db6e01d2c3902fdcaa6a4d0282def1100a65d" => :high_sierra
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
