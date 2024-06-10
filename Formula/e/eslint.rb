require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.4.0.tgz"
  sha256 "c2bf1ad370e87777699a048918f16aac7cfd40849f1e42799446f4be6f9e03b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0a1a9b2786e5de83f483c5df974207ed48d46a4b23a0bfcfa6243f03b6a6630"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0a1a9b2786e5de83f483c5df974207ed48d46a4b23a0bfcfa6243f03b6a6630"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0a1a9b2786e5de83f483c5df974207ed48d46a4b23a0bfcfa6243f03b6a6630"
    sha256 cellar: :any_skip_relocation, sonoma:         "8181d2ab4a3535aed23ae2a7b195a3f3ca9c91c80da01aeaef92734212f84499"
    sha256 cellar: :any_skip_relocation, ventura:        "e49c94d04830bc02035bf17e893e4aa2ed336edcddd7c827f867a30ea11be257"
    sha256 cellar: :any_skip_relocation, monterey:       "e49c94d04830bc02035bf17e893e4aa2ed336edcddd7c827f867a30ea11be257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e206d35d80d9aa1c0719d9c3cce6ed7aa1dc43c07788754447818d64af4ebe12"
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
