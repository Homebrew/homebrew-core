require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-5.8.0.tgz"
  sha256 "74e2054958c27e75975bb1b2c3f4e997651410850bc0264d05b9871a474165de"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd58c4f3c9f7d1c32191b09db42e9afcf13bc4d78598538f605e54350754c692" => :mojave
    sha256 "bcf36cdd38afc91697951089033e4d7b83de202b7a57ded69f61214659006483" => :high_sierra
    sha256 "ec39eda677a6cb6b3b4c9413b52a1250f9709c705efc680182712a94a1d03acf" => :sierra
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
