require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.28.0.tgz"
  sha256 "3602874f8c55414d7b60f3f1be5d6c6801ac1a90088848c6f9455a4dee978929"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5872cb5fc95353de2b10a66d25e48f9c2037bb8ab6759c76d18c1924d39aaa6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5872cb5fc95353de2b10a66d25e48f9c2037bb8ab6759c76d18c1924d39aaa6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5872cb5fc95353de2b10a66d25e48f9c2037bb8ab6759c76d18c1924d39aaa6d"
    sha256 cellar: :any_skip_relocation, monterey:       "672c636f0808746625fc03930f7035c1c24beea1732017849f203b67d87d3059"
    sha256 cellar: :any_skip_relocation, big_sur:        "672c636f0808746625fc03930f7035c1c24beea1732017849f203b67d87d3059"
    sha256 cellar: :any_skip_relocation, catalina:       "672c636f0808746625fc03930f7035c1c24beea1732017849f203b67d87d3059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5872cb5fc95353de2b10a66d25e48f9c2037bb8ab6759c76d18c1924d39aaa6d"
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
