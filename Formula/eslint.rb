require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-6.6.0.tgz"
  sha256 "1f0a967e2ba5cece30a3bae1a82ae6fe10fcf04f52b346375fd8def902407baa"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f78ea87b6bea3339b9027f073baf899e8fbd27a5a46b9b49e4abfe7d373775a" => :catalina
    sha256 "5faca95a8af36d6fca43f85b99241b0f7e6f74f1873b201238e4c4a26af65cf7" => :mojave
    sha256 "712c6c238ab445dff9f8eafc2342724bac7308a35911a9e716dd6e77c36dfd85" => :high_sierra
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
