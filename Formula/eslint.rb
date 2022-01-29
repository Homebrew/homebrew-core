require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.8.0.tgz"
  sha256 "5ac710d1f3a86b8017727b99bc1dfad542503bde98f9167cb4c3bdf33d0885d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba8527ff3a50bbd8c18ceb53545248f9a4097ae93ff196ab2f990d0eb0ecfbe2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba8527ff3a50bbd8c18ceb53545248f9a4097ae93ff196ab2f990d0eb0ecfbe2"
    sha256 cellar: :any_skip_relocation, monterey:       "428f82e41f6fadee7a2cff55139327f2f757c5d3fca030451e13ca98dbcf3564"
    sha256 cellar: :any_skip_relocation, big_sur:        "428f82e41f6fadee7a2cff55139327f2f757c5d3fca030451e13ca98dbcf3564"
    sha256 cellar: :any_skip_relocation, catalina:       "428f82e41f6fadee7a2cff55139327f2f757c5d3fca030451e13ca98dbcf3564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba8527ff3a50bbd8c18ceb53545248f9a4097ae93ff196ab2f990d0eb0ecfbe2"
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
