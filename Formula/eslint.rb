require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.12.1.tgz"
  sha256 "06049fda3c7b3c21f5d2ceea388c3338d30563d445cb59a1db6cc94fbf280b25"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5093809e9a7b0f92ceb66d23ef38a909c12680a77db83828d338fa9bcd796f90" => :catalina
    sha256 "67aed2b7bd873226f7f57ed68207222bc6794ecde1c5bfc678a551f2b949602a" => :mojave
    sha256 "0682d818c78349a1ce037c11c917327ed63095c504e5990b3b273630984e2cd3" => :high_sierra
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
