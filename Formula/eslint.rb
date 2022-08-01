require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.21.0.tgz"
  sha256 "da367afe8cda38a8a8d75d8206c37106e67a327c7403293be621e5b1566e6d25"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87d263d1fa8e923b6c92cf5015ecd29f1d323e69d91f9e1c25dd7a7f7bca7ea8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87d263d1fa8e923b6c92cf5015ecd29f1d323e69d91f9e1c25dd7a7f7bca7ea8"
    sha256 cellar: :any_skip_relocation, monterey:       "fc02aa2161c25d2a5d1168399239ad88caa7323cab74180011a55f086aee1b2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc02aa2161c25d2a5d1168399239ad88caa7323cab74180011a55f086aee1b2f"
    sha256 cellar: :any_skip_relocation, catalina:       "fc02aa2161c25d2a5d1168399239ad88caa7323cab74180011a55f086aee1b2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87d263d1fa8e923b6c92cf5015ecd29f1d323e69d91f9e1c25dd7a7f7bca7ea8"
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
