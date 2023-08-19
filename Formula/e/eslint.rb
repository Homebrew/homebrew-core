require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.47.0.tgz"
  sha256 "9216defbe8ae993053e0abd999554d6cccfa7c0d87a3f203f614547ac6d239a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34723fdae870678cebcf0a7fe0a8dbba8f0b471cbedeefdbdf47d616771f9634"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34723fdae870678cebcf0a7fe0a8dbba8f0b471cbedeefdbdf47d616771f9634"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34723fdae870678cebcf0a7fe0a8dbba8f0b471cbedeefdbdf47d616771f9634"
    sha256 cellar: :any_skip_relocation, ventura:        "a23e0a27e810a9817b0cbad271ad4852e28b1af8f1783467c21582ebd5005140"
    sha256 cellar: :any_skip_relocation, monterey:       "a23e0a27e810a9817b0cbad271ad4852e28b1af8f1783467c21582ebd5005140"
    sha256 cellar: :any_skip_relocation, big_sur:        "a23e0a27e810a9817b0cbad271ad4852e28b1af8f1783467c21582ebd5005140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34723fdae870678cebcf0a7fe0a8dbba8f0b471cbedeefdbdf47d616771f9634"
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
