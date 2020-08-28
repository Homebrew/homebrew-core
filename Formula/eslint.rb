require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.7.0.tgz"
  sha256 "ba07f1b38b995c5a9fb05794cc894d88c0ca707c23b062b3aa63b3d2caab58ce"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2174ccc91acb2621f20322b72be72d3eb3e533577665f01485e5878d9f21d988" => :catalina
    sha256 "5970f9d6b1609505e3f9182c51b49dbb410b1262d2ab4e066a65ffd4a2b19ebb" => :mojave
    sha256 "3d845d73013be6de9b872b2605a69b28032bb1c91b1ba7de0e3a1f04f8e05f2e" => :high_sierra
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
