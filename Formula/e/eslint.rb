require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.56.0.tgz"
  sha256 "48603d6a30615b5e563307b7a315ba1f04339dfe8a4ad7971dea23dfba1fb430"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7b6e00e0f1f0423799130fb2a809a4d743c6dc39ced2cc2765a539bfa37ec6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7b6e00e0f1f0423799130fb2a809a4d743c6dc39ced2cc2765a539bfa37ec6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7b6e00e0f1f0423799130fb2a809a4d743c6dc39ced2cc2765a539bfa37ec6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "74349aac80a0c98eeb594881e5e80807514e7fe7cec01074f28767531b230e11"
    sha256 cellar: :any_skip_relocation, ventura:        "74349aac80a0c98eeb594881e5e80807514e7fe7cec01074f28767531b230e11"
    sha256 cellar: :any_skip_relocation, monterey:       "74349aac80a0c98eeb594881e5e80807514e7fe7cec01074f28767531b230e11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7b6e00e0f1f0423799130fb2a809a4d743c6dc39ced2cc2765a539bfa37ec6c"
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
