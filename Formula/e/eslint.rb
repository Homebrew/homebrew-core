class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.18.0.tgz"
  sha256 "56e9b6204ea80006dfafab7fc3a184aec6922923fab25bb1f4a9d71b94059684"
  license "MIT"
  head "https://github.com/eslint/eslint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1e0d395a083e36a35399f67355416b50ce71656452609c74374105218cfb2be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1e0d395a083e36a35399f67355416b50ce71656452609c74374105218cfb2be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1e0d395a083e36a35399f67355416b50ce71656452609c74374105218cfb2be"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fc0e496b142760ad9384a334f2e2ccd2b0e73777ddd17f396c47d89c9e2674c"
    sha256 cellar: :any_skip_relocation, ventura:       "5fc0e496b142760ad9384a334f2e2ccd2b0e73777ddd17f396c47d89c9e2674c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1e0d395a083e36a35399f67355416b50ce71656452609c74374105218cfb2be"
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
