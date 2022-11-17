require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.27.0.tgz"
  sha256 "1b22391dcf314698c65997e8f278473ee7b59b1c122ddb22d754bb99dd1aa79b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f59f8b3d88248759ca8af3677483185d2da7f990ed0963232a2fde8fe52ba295"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f59f8b3d88248759ca8af3677483185d2da7f990ed0963232a2fde8fe52ba295"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f59f8b3d88248759ca8af3677483185d2da7f990ed0963232a2fde8fe52ba295"
    sha256 cellar: :any_skip_relocation, ventura:        "6d63d101e40fc44f14d2d5ed432cacb8cb245fe5606c9a37cc58fb1573f9c662"
    sha256 cellar: :any_skip_relocation, monterey:       "a326b5b84a6f3b1a40193f35d5a2918c54442106a9a493623d8682422662edef"
    sha256 cellar: :any_skip_relocation, big_sur:        "a326b5b84a6f3b1a40193f35d5a2918c54442106a9a493623d8682422662edef"
    sha256 cellar: :any_skip_relocation, catalina:       "a326b5b84a6f3b1a40193f35d5a2918c54442106a9a493623d8682422662edef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f59f8b3d88248759ca8af3677483185d2da7f990ed0963232a2fde8fe52ba295"
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
