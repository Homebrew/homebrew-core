require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.8.1.tgz"
  sha256 "585eae1741de549b142065927fa5555f32b8b0f0ca8ffd7965812f972a8c311a"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0bf417a3366fb4f05809d09f84f6295d22c17db30bad32aa484ccc89be2fb498" => :catalina
    sha256 "4a096700ccba6ba138cddf772140571fc35a8c79222171f955d35d56ff392bd5" => :mojave
    sha256 "4722fe643211b080225ccbae9645ee600cf3ddf415407d8e52ddba678536619f" => :high_sierra
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
