require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-5.5.0.tgz"
  sha256 "5e05603dd9bb660649649329ee7666f749e943ca30b8121ab2660c4654f5aabf"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd75a811cb26831b6977077e7b8b2d64d2c10546505e0cd40f3c583070f5b6ca" => :mojave
    sha256 "72865b84561a708af22915e3365b59632cbb6aa93e988c7942d2fab8d7d045b2" => :high_sierra
    sha256 "a8112d802e23e3340164f42f93e4e1cf95de38e27e54c7586977bda576e77435" => :sierra
    sha256 "e49345305996a65e0f61f2fd634a679788636443a176b8e9bb57f25681f3a712" => :el_capitan
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
