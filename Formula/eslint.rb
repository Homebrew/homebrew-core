require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-6.7.2.tgz"
  sha256 "0ae86f940a88d1348934f0ea4be2558c3bd25721e9e9ef97903729452042c862"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4e4e5446eb6a32fc21306fcad2926009c934c76d4c33ae89e2e20bda1e0b768" => :catalina
    sha256 "570c659a6bff47e194bec17554d72dd99b2d386c5ee5e4bdb700e9f339a00ccb" => :mojave
    sha256 "6bc675d8a048dd93a9a64f71e5db3e9a2a9de0efa4bc83ae1a1b95986ae8f5ac" => :high_sierra
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
