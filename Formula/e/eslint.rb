class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.26.0.tgz"
  sha256 "71c4c10714afa94e0fcf8f32c714c0944e7ed32d4d72beb18caa71d7e8709521"
  license "MIT"
  head "https://github.com/eslint/eslint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8efb17c34c932963e586d1802fa3ba0e9c9f14df042ed4cbb901a28536d5596b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8efb17c34c932963e586d1802fa3ba0e9c9f14df042ed4cbb901a28536d5596b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8efb17c34c932963e586d1802fa3ba0e9c9f14df042ed4cbb901a28536d5596b"
    sha256 cellar: :any_skip_relocation, sonoma:        "be05efe83d2d36009e715f887203fec1f768bb3343458b25259d0963fea6339c"
    sha256 cellar: :any_skip_relocation, ventura:       "be05efe83d2d36009e715f887203fec1f768bb3343458b25259d0963fea6339c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8efb17c34c932963e586d1802fa3ba0e9c9f14df042ed4cbb901a28536d5596b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8efb17c34c932963e586d1802fa3ba0e9c9f14df042ed4cbb901a28536d5596b"
  end

  depends_on "node"

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
