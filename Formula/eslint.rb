require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.18.0.tgz"
  sha256 "9047318809273f2538f1e0b32dd63b597ded6b478b54c8278767b2d0462ff3d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3042979010904352c115186b6388c398c4ddd602125a2b13b134c396f010f6e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3042979010904352c115186b6388c398c4ddd602125a2b13b134c396f010f6e6"
    sha256 cellar: :any_skip_relocation, monterey:       "afcaee1504237a1e0b666651cd5f444aa3d3e371e5b5aecdd80af39c943a12ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "afcaee1504237a1e0b666651cd5f444aa3d3e371e5b5aecdd80af39c943a12ba"
    sha256 cellar: :any_skip_relocation, catalina:       "afcaee1504237a1e0b666651cd5f444aa3d3e371e5b5aecdd80af39c943a12ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3042979010904352c115186b6388c398c4ddd602125a2b13b134c396f010f6e6"
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
