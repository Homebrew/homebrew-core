require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-6.5.1.tgz"
  sha256 "0baccbab5b74c10a4c1ade09978278da7d25c6b29644e9e930dbf541b6f7e921"

  bottle do
    cellar :any_skip_relocation
    sha256 "cdb7a984a2d009328509d377564186123994049cc8ba2a7e41c4039433b8ae8b" => :catalina
    sha256 "006e0f27a0a9272dac6e736c3235589f8f4d05921de41fc5f1975bacba16c24f" => :mojave
    sha256 "4b5fcca739149e387b29e148fb3ebda2e400fe6a948c33fa924c9ef3c79268cc" => :high_sierra
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
