class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.9.0.tgz"
  sha256 "b0e2456f7181b00a6005fcbda4f635eee6f175ee87c8dc593fb75337d575d5eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a58933e6031ec51a7fc6422ec56cf9fb0252fb984b56f392372ab7d0a3c10c6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a58933e6031ec51a7fc6422ec56cf9fb0252fb984b56f392372ab7d0a3c10c6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a58933e6031ec51a7fc6422ec56cf9fb0252fb984b56f392372ab7d0a3c10c6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc921be29d7e30093cf2d6574c2def9011e8f987c41f732674b32672f32a7777"
    sha256 cellar: :any_skip_relocation, ventura:        "fc921be29d7e30093cf2d6574c2def9011e8f987c41f732674b32672f32a7777"
    sha256 cellar: :any_skip_relocation, monterey:       "fc921be29d7e30093cf2d6574c2def9011e8f987c41f732674b32672f32a7777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a58933e6031ec51a7fc6422ec56cf9fb0252fb984b56f392372ab7d0a3c10c6f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
