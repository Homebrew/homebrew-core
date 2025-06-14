class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.29.0.tgz"
  sha256 "71597d5fd0865e8d5d26317923f6243c0787165f6326871b69f4c330da03a580"
  license "MIT"
  head "https://github.com/eslint/eslint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6c5d5ca473c803f423def1a6e8a5f3b4ecde4bf088cb02c0ff2a09b1177822a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6c5d5ca473c803f423def1a6e8a5f3b4ecde4bf088cb02c0ff2a09b1177822a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d6c5d5ca473c803f423def1a6e8a5f3b4ecde4bf088cb02c0ff2a09b1177822a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7eddc07d0c1fba367331e1fe16e87e0646bd2ea97fd3c756d779fb2d4c3dd352"
    sha256 cellar: :any_skip_relocation, ventura:       "7eddc07d0c1fba367331e1fe16e87e0646bd2ea97fd3c756d779fb2d4c3dd352"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6c5d5ca473c803f423def1a6e8a5f3b4ecde4bf088cb02c0ff2a09b1177822a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6c5d5ca473c803f423def1a6e8a5f3b4ecde4bf088cb02c0ff2a09b1177822a"
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
