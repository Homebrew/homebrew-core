require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.7.0.tgz"
  sha256 "4995e96e0abdc29ca40a564ff572f248f6910eb06083a0cf1488a889ac6cbfab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85ddb576fb0083936978357b7a4ffae334e420158d5d88c6c7770b828d085c28"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85ddb576fb0083936978357b7a4ffae334e420158d5d88c6c7770b828d085c28"
    sha256 cellar: :any_skip_relocation, monterey:       "006651a865685a5fb8a86295da10a5e51d6c45e1c2c1dcbb16f1ff90d4b7a300"
    sha256 cellar: :any_skip_relocation, big_sur:        "006651a865685a5fb8a86295da10a5e51d6c45e1c2c1dcbb16f1ff90d4b7a300"
    sha256 cellar: :any_skip_relocation, catalina:       "006651a865685a5fb8a86295da10a5e51d6c45e1c2c1dcbb16f1ff90d4b7a300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85ddb576fb0083936978357b7a4ffae334e420158d5d88c6c7770b828d085c28"
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
