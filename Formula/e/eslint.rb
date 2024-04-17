require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.0.0.tgz"
  sha256 "b3d6290a0f443e43eea6e52417cae956294347f12ee0933461f566f9ee3e1625"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc6fb9987aae08dede5e712802e4106c1cda644667eaeed775cc457c362e25dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc6fb9987aae08dede5e712802e4106c1cda644667eaeed775cc457c362e25dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc6fb9987aae08dede5e712802e4106c1cda644667eaeed775cc457c362e25dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "0024f08096880363642414789dd2ad7fbd6da39bc16dbe7ef2e614256b88bd3c"
    sha256 cellar: :any_skip_relocation, ventura:        "0024f08096880363642414789dd2ad7fbd6da39bc16dbe7ef2e614256b88bd3c"
    sha256 cellar: :any_skip_relocation, monterey:       "0024f08096880363642414789dd2ad7fbd6da39bc16dbe7ef2e614256b88bd3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc6fb9987aae08dede5e712802e4106c1cda644667eaeed775cc457c362e25dd"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
