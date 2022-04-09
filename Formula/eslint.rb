require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.13.0.tgz"
  sha256 "8b87894c0c7b166d56af3dea25fc9a6db4955a7bf8caba31bdc898e9456df86c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f978a5af7317bf064f3e2ebf1e30012c31edad73c79ad13ac60a513f51991b2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f978a5af7317bf064f3e2ebf1e30012c31edad73c79ad13ac60a513f51991b2f"
    sha256 cellar: :any_skip_relocation, monterey:       "6ee44876bbd74cbe2f766214dc85f35737a825961be64476684b9877f0df0191"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ee44876bbd74cbe2f766214dc85f35737a825961be64476684b9877f0df0191"
    sha256 cellar: :any_skip_relocation, catalina:       "6ee44876bbd74cbe2f766214dc85f35737a825961be64476684b9877f0df0191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f978a5af7317bf064f3e2ebf1e30012c31edad73c79ad13ac60a513f51991b2f"
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
