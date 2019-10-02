require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-6.5.1.tgz"
  sha256 "0baccbab5b74c10a4c1ade09978278da7d25c6b29644e9e930dbf541b6f7e921"

  bottle do
    cellar :any_skip_relocation
    sha256 "926163199904d146f2fb8acc002369b22405b913f4cf1ea882abc58a9e5b8619" => :catalina
    sha256 "9b7d487b634d823ee2af898996d6a0ba3c4043c3b813d3c0fb4cf4166cd58896" => :mojave
    sha256 "57c36bb3cd70b7ae6865fdb307ab2d0428cf3fb58ffb77a4ae40abd2c95ceed7" => :high_sierra
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
