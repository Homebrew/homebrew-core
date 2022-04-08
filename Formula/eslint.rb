require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.13.0.tgz"
  sha256 "8b87894c0c7b166d56af3dea25fc9a6db4955a7bf8caba31bdc898e9456df86c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26febf223977df018ba4888e868e1ab7125b33129a2b8700117aff602448fd1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26febf223977df018ba4888e868e1ab7125b33129a2b8700117aff602448fd1c"
    sha256 cellar: :any_skip_relocation, monterey:       "941754221ae93515b2a5eff80cca0f19215680110c9f05a1b52125dfe0e3067c"
    sha256 cellar: :any_skip_relocation, big_sur:        "941754221ae93515b2a5eff80cca0f19215680110c9f05a1b52125dfe0e3067c"
    sha256 cellar: :any_skip_relocation, catalina:       "941754221ae93515b2a5eff80cca0f19215680110c9f05a1b52125dfe0e3067c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26febf223977df018ba4888e868e1ab7125b33129a2b8700117aff602448fd1c"
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
