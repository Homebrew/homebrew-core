require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-6.1.0.tgz"
  sha256 "3ee88df148b40720c2fe2b1e1c3fa90b2eb2a512902c48897df7a905115608c1"

  bottle do
    cellar :any_skip_relocation
    sha256 "865fdf1b4aa5fc9c2d4826b29805c78762442b6cf46cfdab3e72ed4ed0e528f0" => :mojave
    sha256 "b5583e5ac940d4ddda0a01681025be568fde7e9e432795a27a0439b892cc97c9" => :high_sierra
    sha256 "5342050a4f03b30cdd8aedf5acfa98675c319ced946621f0d2ec1822965a8fd4" => :sierra
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
