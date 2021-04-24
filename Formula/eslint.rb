require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.25.0.tgz"
  sha256 "1d7a384fb2bd88d1ae3718e1515b1a3949a1fce8b0d650e0a0727ec3c8972d86"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0a13c33526d3a44b4f7e019f32feb86e2138ac773957efc7c6e0a08e8c826917"
    sha256 cellar: :any_skip_relocation, big_sur:       "d14a5f72b020df3e26b817e821382ab5639962e5700c4421d4baa6b8ae541cac"
    sha256 cellar: :any_skip_relocation, catalina:      "69f69a1c944854397330dbb5a6a85cd845b72be3c4ffe573017517d9611244a9"
    sha256 cellar: :any_skip_relocation, mojave:        "c622acd7501b5a9bc14f1565fc46e4f07e3f587d555df69a09f3f3d59f9b5346"
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
