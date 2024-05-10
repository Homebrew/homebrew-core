require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.2.0.tgz"
  sha256 "2a8c4e9ab940dbe6bcbaf3edceb439a2dddf149b3597a6a67e8b52bac3d41407"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1bf3421dc7d627e162f184654f8d93ac6b57f2d6a7268bacf3580e2a5bdee34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1bf3421dc7d627e162f184654f8d93ac6b57f2d6a7268bacf3580e2a5bdee34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1bf3421dc7d627e162f184654f8d93ac6b57f2d6a7268bacf3580e2a5bdee34"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9013e84bc572ce3c4f06ce19344f1d3280f282965e5d5fcdcf59da33acde5e0"
    sha256 cellar: :any_skip_relocation, ventura:        "a9013e84bc572ce3c4f06ce19344f1d3280f282965e5d5fcdcf59da33acde5e0"
    sha256 cellar: :any_skip_relocation, monterey:       "a9013e84bc572ce3c4f06ce19344f1d3280f282965e5d5fcdcf59da33acde5e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1bf3421dc7d627e162f184654f8d93ac6b57f2d6a7268bacf3580e2a5bdee34"
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
