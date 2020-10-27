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
    sha256 "4c6a518a7b2955015bfa32bea6a98a5dc4661a128895e13e25f5d9d8b0d6f634" => :catalina
    sha256 "b7f7ea8376c9b7d3514923c225ffe89d4950c130551e611745745950995c788c" => :mojave
    sha256 "55c3a89a7f556e706b9b0f2dda2d24cb7309e9c21546f8f0967587fad9647666" => :high_sierra
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
