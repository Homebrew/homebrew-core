require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.0.1.tgz"
  sha256 "a2ef88b0bf5e93a9284a95f244ce3effd5e9e906c38eb8c31076452716cae325"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dd389ce647da3e17755816088396e052fcb53b33aa5f27ae02ee5c7ee826ab39"
    sha256 cellar: :any_skip_relocation, big_sur:       "3ca686a856df6368176cf81b2a8d7d4cc947272c6ec43da8c623a82a92072c57"
    sha256 cellar: :any_skip_relocation, catalina:      "3ca686a856df6368176cf81b2a8d7d4cc947272c6ec43da8c623a82a92072c57"
    sha256 cellar: :any_skip_relocation, mojave:        "3ca686a856df6368176cf81b2a8d7d4cc947272c6ec43da8c623a82a92072c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd389ce647da3e17755816088396e052fcb53b33aa5f27ae02ee5c7ee826ab39"
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
