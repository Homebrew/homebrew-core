class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.24.0.tgz"
  sha256 "ac05e44278c06bd0c9fa21d8a6cf0903660e64297523003be72f4b57842b89de"
  license "MIT"
  head "https://github.com/eslint/eslint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50bf8b487b34cfba11fb3ac7dc3a1e9b42657afc04f54f7d962b770953338356"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50bf8b487b34cfba11fb3ac7dc3a1e9b42657afc04f54f7d962b770953338356"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50bf8b487b34cfba11fb3ac7dc3a1e9b42657afc04f54f7d962b770953338356"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2612d942d50dbc2f0c21289f9297e72b241ece9f9308b6f6676b0ec973761dc"
    sha256 cellar: :any_skip_relocation, ventura:       "a2612d942d50dbc2f0c21289f9297e72b241ece9f9308b6f6676b0ec973761dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50bf8b487b34cfba11fb3ac7dc3a1e9b42657afc04f54f7d962b770953338356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50bf8b487b34cfba11fb3ac7dc3a1e9b42657afc04f54f7d962b770953338356"
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
