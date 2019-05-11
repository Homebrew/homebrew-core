require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-5.16.0.tgz"
  sha256 "3cfba056bf19cb13b9f977a3d977059da656631168b60074101b1187014c5bb1"

  bottle do
    cellar :any_skip_relocation
    sha256 "65a4cc74657fe0c82fb4ce9bc638fa1a777cc8d2e0cdf07380ab414711217371" => :mojave
    sha256 "19f7892e5a8f30c1e4a9af550ff3666dd640966e3a08f437213d0efaf370bc93" => :high_sierra
    sha256 "d516c75f3a9e1218296f8f4673027b3400f1fad310aa0ae29016e8cc0dec36f3" => :sierra
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
