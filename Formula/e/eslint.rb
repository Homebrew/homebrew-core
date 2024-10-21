class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.13.0.tgz"
  sha256 "531ba3a9db85f4e88f9ea996ce43c16d3f8694f7f48f3b2e00b4399d5cecfe47"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f6577bbd063b50795835b8d0acae3e33f103169e5a127c6a0a37a93beccb605"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f6577bbd063b50795835b8d0acae3e33f103169e5a127c6a0a37a93beccb605"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f6577bbd063b50795835b8d0acae3e33f103169e5a127c6a0a37a93beccb605"
    sha256 cellar: :any_skip_relocation, sonoma:        "a562ad08a14b2dca32ce614f6afe61412d4b943654042fddc1738f99af6b37af"
    sha256 cellar: :any_skip_relocation, ventura:       "a562ad08a14b2dca32ce614f6afe61412d4b943654042fddc1738f99af6b37af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f6577bbd063b50795835b8d0acae3e33f103169e5a127c6a0a37a93beccb605"
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
