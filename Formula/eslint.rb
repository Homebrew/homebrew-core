require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.40.0.tgz"
  sha256 "842ea9b31d7667ccb97f3a6a69ad7c957c3a5bc1c344c7bde2727fc7ab12a498"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88385064f9380d93671131abec2a585f43b4e692fafb87bbc3c74f626481be58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88385064f9380d93671131abec2a585f43b4e692fafb87bbc3c74f626481be58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88385064f9380d93671131abec2a585f43b4e692fafb87bbc3c74f626481be58"
    sha256 cellar: :any_skip_relocation, ventura:        "8b927a6c024db147a7731cb2bddbc56ec1d4ed3df000b72f95c9c1a34ed5ef4a"
    sha256 cellar: :any_skip_relocation, monterey:       "8b927a6c024db147a7731cb2bddbc56ec1d4ed3df000b72f95c9c1a34ed5ef4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b927a6c024db147a7731cb2bddbc56ec1d4ed3df000b72f95c9c1a34ed5ef4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88385064f9380d93671131abec2a585f43b4e692fafb87bbc3c74f626481be58"
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
