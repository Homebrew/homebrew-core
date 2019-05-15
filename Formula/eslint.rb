require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-5.16.0.tgz"
  sha256 "3cfba056bf19cb13b9f977a3d977059da656631168b60074101b1187014c5bb1"

  bottle do
    cellar :any_skip_relocation
    sha256 "595aa88f5a43b5f7227f0cb923eee989d505879ac0527777d6f784d38a2d6332" => :mojave
    sha256 "14238aa19dc60f1b27510ee7964ea58c8f0383f27f74f79c89e40813663bbdbf" => :high_sierra
    sha256 "630fb61b82e6aa59283ba4f90c4d0519eabe9359a14d1d0016ee8455a84ee467" => :sierra
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
