class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-10.16.0.tgz"
  sha256 "dd276c6ce30dce8c2a2ab63db48f814baa2f492e85e7b124d9976d7bb023b751"
  license "MIT"
  head "https://github.com/eslint/eslint.git", branch: "main"

  bottle do
    manifest_sha256 "b07f12e25fb3c096df77f953fbc8d622efd11e23e0268019e5532a1002e4f0d8"
    sha256 cellar: :any_skip_relocation, all: "acbb42bfe8be081927a2ca11dc65a9e763fafd9d71f2d1eb2e9ff51602b88c8e"
  end

  depends_on "node"

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
