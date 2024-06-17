require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.5.0.tgz"
  sha256 "545fc9401837001f9c7e215220e4b4a2b24471411fc02a06a9fee14709af2079"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e0b988db1e6687b07d00bb3cd0dd698fed09a664570bbfed94e1c8c77a48564"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e0b988db1e6687b07d00bb3cd0dd698fed09a664570bbfed94e1c8c77a48564"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e0b988db1e6687b07d00bb3cd0dd698fed09a664570bbfed94e1c8c77a48564"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fc29e3ff848cf7340b2251cb42eba342a9c073c72f1dc057b4053b024933c36"
    sha256 cellar: :any_skip_relocation, ventura:        "8fc29e3ff848cf7340b2251cb42eba342a9c073c72f1dc057b4053b024933c36"
    sha256 cellar: :any_skip_relocation, monterey:       "8fc29e3ff848cf7340b2251cb42eba342a9c073c72f1dc057b4053b024933c36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "395d677d68c972e943e43cf39a8d70caf00b657f06441c6d7c73a1bbc2f9a14e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # https://eslint.org/docs/latest/use/configure/configuration-files#configuration-file
    (testpath/"eslint.config.js").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")

    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end
