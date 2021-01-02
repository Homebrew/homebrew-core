require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.17.0.tgz"
  sha256 "b1e1572824777214bd768d1d05d5af133a97d5cfe5f8d01933098e79e5573cfa"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6cab22263fc58e65af775f262f81831445c7f60456e655092a3c2599067c86d2" => :big_sur
    sha256 "d3b6fcd8aadee668d0828495e686dcf4199ba16cea676a5ec4281378b8981e0b" => :arm64_big_sur
    sha256 "970779be8dbc860b22e8d79570e6feda7c2c3b973c9899988fd1b851a9d30295" => :catalina
    sha256 "a188c731c5994457c25d794b0e078dec0db098d90c4fcf4f5ddd57340c2e4725" => :mojave
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
