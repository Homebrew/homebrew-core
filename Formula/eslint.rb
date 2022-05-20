require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.15.0.tgz"
  sha256 "4025d206b3829e9c3b93464c67258047c431062c71a31e74e6328067c80304b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d0d445657cd4e1e9f1666ba35700e8f85ba83acbe5640d5906758c8c80bdc3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d0d445657cd4e1e9f1666ba35700e8f85ba83acbe5640d5906758c8c80bdc3e"
    sha256 cellar: :any_skip_relocation, monterey:       "d162aa1e3f1ff0878f96550d2204e31f3aa292be9baadf127973b363a1e7b25c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d162aa1e3f1ff0878f96550d2204e31f3aa292be9baadf127973b363a1e7b25c"
    sha256 cellar: :any_skip_relocation, catalina:       "d162aa1e3f1ff0878f96550d2204e31f3aa292be9baadf127973b363a1e7b25c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d0d445657cd4e1e9f1666ba35700e8f85ba83acbe5640d5906758c8c80bdc3e"
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
