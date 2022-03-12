require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.11.0.tgz"
  sha256 "8be9af064cd87d3e7e6700b86e61883c8b9ca1eb0b3cc4fd8825017ec57314f7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60b000a154382bf463b42aa93673b47b35c0f40a54226a282a1bbef9d710970e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60b000a154382bf463b42aa93673b47b35c0f40a54226a282a1bbef9d710970e"
    sha256 cellar: :any_skip_relocation, monterey:       "b44436db53022ff30c2925b17dd6f06b61e965b61a32fe5db334df9d74c11bb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b44436db53022ff30c2925b17dd6f06b61e965b61a32fe5db334df9d74c11bb4"
    sha256 cellar: :any_skip_relocation, catalina:       "b44436db53022ff30c2925b17dd6f06b61e965b61a32fe5db334df9d74c11bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60b000a154382bf463b42aa93673b47b35c0f40a54226a282a1bbef9d710970e"
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
