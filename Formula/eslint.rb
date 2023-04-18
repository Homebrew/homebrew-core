require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.38.0.tgz"
  sha256 "4f90abb62f91f784d38e56f6f1752bee019356cfe119aaaa8b9b0b1de3defbd0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9a8f2acf2a5dc51f54e25fea862a56a1baf1e4efb8f7c51d8b76042820b6229"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9a8f2acf2a5dc51f54e25fea862a56a1baf1e4efb8f7c51d8b76042820b6229"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9a8f2acf2a5dc51f54e25fea862a56a1baf1e4efb8f7c51d8b76042820b6229"
    sha256 cellar: :any_skip_relocation, ventura:        "6540329bed4d5412ca11580d5de7eb4fb60175624659f3800da0709905ae3e92"
    sha256 cellar: :any_skip_relocation, monterey:       "6540329bed4d5412ca11580d5de7eb4fb60175624659f3800da0709905ae3e92"
    sha256 cellar: :any_skip_relocation, big_sur:        "6540329bed4d5412ca11580d5de7eb4fb60175624659f3800da0709905ae3e92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9a8f2acf2a5dc51f54e25fea862a56a1baf1e4efb8f7c51d8b76042820b6229"
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
