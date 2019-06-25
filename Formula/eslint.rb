require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-6.0.1.tgz"
  sha256 "9afb306e83be373a3e68185ac04e01a1c5e9b640c9ea6df2516e97dd273aeb4d"

  bottle do
    cellar :any_skip_relocation
    sha256 "3421090c47b0d4a787220057886cd930a7154226d0cd4438ecd0efcce291a8c6" => :mojave
    sha256 "ea483915fafcc915d3d8f8e61ea60fbb7e75a851610392a799ba21ba4781ac87" => :high_sierra
    sha256 "700c8d1dc9e3ba5885e89352c27f8ec1d88450b97a8e175676cb6ffc741d71a6" => :sierra
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
