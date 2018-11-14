require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-5.9.0.tgz"
  sha256 "5efa81dfad297759368bb859b87682bc9655414d62da39fba92816ae60b03c33"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed8c5cb7f54caa36e9a69b3d069bb2f6bb8e75b64073ca138e95f4852e740dfd" => :mojave
    sha256 "abcbb8e3c444132c56bd9285e40342136faed8e953ee41094822fe63e5d86cf9" => :high_sierra
    sha256 "1c6cdd0dde0190e4531e8010196b4a173dbacdb446c6d3e853ca6f1f0724ecc5" => :sierra
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
