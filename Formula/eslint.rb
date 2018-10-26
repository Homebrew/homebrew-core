require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-5.8.0.tgz"
  sha256 "74e2054958c27e75975bb1b2c3f4e997651410850bc0264d05b9871a474165de"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8ab06b851565f6018d9f2d7ece1e42afa4e6049d5caf921c9f1847f11874f47" => :mojave
    sha256 "148ec1b97a330dcba96b0a58ce57a37b8ddfbe0a1f065b84855734bdc305a552" => :high_sierra
    sha256 "2c6e380b06abaefa01a7c64df5e655733a92817ec0bc0828b747449a6b16deb0" => :sierra
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
