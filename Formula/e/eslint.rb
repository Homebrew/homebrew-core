class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.25.1.tgz"
  sha256 "b07029c0b182403d7a12352356871658b51d70f20d9fcd3b2d04b6e8c447601c"
  license "MIT"
  head "https://github.com/eslint/eslint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90d72a9825c818052469a9b85a9e6627fef350144cdc1e8a2c765fcc4d6e0117"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90d72a9825c818052469a9b85a9e6627fef350144cdc1e8a2c765fcc4d6e0117"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90d72a9825c818052469a9b85a9e6627fef350144cdc1e8a2c765fcc4d6e0117"
    sha256 cellar: :any_skip_relocation, sonoma:        "30cc22ed3d70a634b93ba9cd184c205611a7dfc2f968e4fcdad1549de3e8a5a6"
    sha256 cellar: :any_skip_relocation, ventura:       "30cc22ed3d70a634b93ba9cd184c205611a7dfc2f968e4fcdad1549de3e8a5a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90d72a9825c818052469a9b85a9e6627fef350144cdc1e8a2c765fcc4d6e0117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90d72a9825c818052469a9b85a9e6627fef350144cdc1e8a2c765fcc4d6e0117"
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
