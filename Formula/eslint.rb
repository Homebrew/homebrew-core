require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-5.11.0.tgz"
  sha256 "3847f657771f50a251e00da3b3bef8635515e000f1b19978be79dac61d729ced"

  bottle do
    cellar :any_skip_relocation
    sha256 "a48824bcea574a0180310f71f08a9917d3d39995d2629f94267bfd17cc8f218d" => :mojave
    sha256 "92e8b7ef66992bf8affe80ea927560d9471125e9ad98e72a82278f34be3afad4" => :high_sierra
    sha256 "577042bc63145c79d0bd0bf3fd91b23991ba72341234609fc3e1443e8a77e28d" => :sierra
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
