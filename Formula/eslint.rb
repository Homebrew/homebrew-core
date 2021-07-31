require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.32.0.tgz"
  sha256 "ff6d4d582ed2f9c6333a794a1e8aef737c0a26b17b2a4de3d39a8c75295fc4a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "def06520e4b8a37193fb92af5c517d40a4f3a0bba3e8b9f13e6795e09ca66653"
    sha256 cellar: :any_skip_relocation, big_sur:       "29d75b0622eb010ba99cae9b225a9fa767fa483db638a93849c61906e564cd90"
    sha256 cellar: :any_skip_relocation, catalina:      "29d75b0622eb010ba99cae9b225a9fa767fa483db638a93849c61906e564cd90"
    sha256 cellar: :any_skip_relocation, mojave:        "29d75b0622eb010ba99cae9b225a9fa767fa483db638a93849c61906e564cd90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "def06520e4b8a37193fb92af5c517d40a4f3a0bba3e8b9f13e6795e09ca66653"
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
