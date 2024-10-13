class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.12.0.tgz"
  sha256 "ab67c1c95b8202705efb25b9a56005c8fcb2e6c007c0b6be542288c1fe1ee10b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e816261b95765e65ebb8473595be5588969fb04a95af26a14634b678eeaacb8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e816261b95765e65ebb8473595be5588969fb04a95af26a14634b678eeaacb8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e816261b95765e65ebb8473595be5588969fb04a95af26a14634b678eeaacb8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "012ff1069a1cd3872e3500ffa3eb484c86ec6dc4ad88e3276ce6160a51b37259"
    sha256 cellar: :any_skip_relocation, ventura:       "012ff1069a1cd3872e3500ffa3eb484c86ec6dc4ad88e3276ce6160a51b37259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e816261b95765e65ebb8473595be5588969fb04a95af26a14634b678eeaacb8b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # https://eslint.org/docs/latest/use/configure/configuration-files#configuration-file
    (testpath/"eslint.config.js").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")

    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end
