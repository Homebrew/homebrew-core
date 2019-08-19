require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-6.2.0.tgz"
  sha256 "a0696297eb84bca9532096c796c367a3980c6ea2a24792c52c4a541d73183cbc"

  bottle do
    cellar :any_skip_relocation
    sha256 "515bf308de15a20874bfa0234c5de79ae8bc78bbba9189015f08f260a37ea9f3" => :mojave
    sha256 "23c51a24aa1dd926b42183ba58372fcfc2092190638c245ec5a59e6cd8922c40" => :high_sierra
    sha256 "162adf54fcd1407b9b7c9370042f8b0096498f922a65fecb2e2154e738b811e9" => :sierra
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
