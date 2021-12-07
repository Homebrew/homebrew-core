require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.4.1.tgz"
  sha256 "d75751e92d4d5b96d981ab902d667fe1b5bb31521c8155fa51dfad1553336ce8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e51265d64d6dd84986f96c25215ab6043bcab5f554bd0b9ffaef342ad9da611d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e51265d64d6dd84986f96c25215ab6043bcab5f554bd0b9ffaef342ad9da611d"
    sha256 cellar: :any_skip_relocation, monterey:       "ff0a34b97e7c4be7cf1b9aa656b486c578120fa4ac6ff94a624196242eb9750c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff0a34b97e7c4be7cf1b9aa656b486c578120fa4ac6ff94a624196242eb9750c"
    sha256 cellar: :any_skip_relocation, catalina:       "ff0a34b97e7c4be7cf1b9aa656b486c578120fa4ac6ff94a624196242eb9750c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e51265d64d6dd84986f96c25215ab6043bcab5f554bd0b9ffaef342ad9da611d"
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
