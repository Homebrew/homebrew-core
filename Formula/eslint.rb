require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.33.0.tgz"
  sha256 "af9ddf776e572e514713ae8fe4b73f346a041bb548576f7e54eaf65cfd16e07e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9caa8aa0cae76e10f4c64eb1290807ffc3c2a7e4aa7f12ce51e46c323889793f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9caa8aa0cae76e10f4c64eb1290807ffc3c2a7e4aa7f12ce51e46c323889793f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9caa8aa0cae76e10f4c64eb1290807ffc3c2a7e4aa7f12ce51e46c323889793f"
    sha256 cellar: :any_skip_relocation, ventura:        "4a08f6bff44825b1030d16d7f0f892ed1ceceab14bd116f65573a85ea4ffcc45"
    sha256 cellar: :any_skip_relocation, monterey:       "4a08f6bff44825b1030d16d7f0f892ed1ceceab14bd116f65573a85ea4ffcc45"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a08f6bff44825b1030d16d7f0f892ed1ceceab14bd116f65573a85ea4ffcc45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9caa8aa0cae76e10f4c64eb1290807ffc3c2a7e4aa7f12ce51e46c323889793f"
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
