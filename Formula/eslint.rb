require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-6.0.1.tgz"
  sha256 "9afb306e83be373a3e68185ac04e01a1c5e9b640c9ea6df2516e97dd273aeb4d"

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
