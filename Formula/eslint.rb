require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.16.0.tgz"
  sha256 "8d173f9c72384fde3e56e462ae7386b260293fa07d2903579061f978df847622"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "818d30946c9c390e69c79adb7d7de4392353b014eb73e38a8edf6bf654061e8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "818d30946c9c390e69c79adb7d7de4392353b014eb73e38a8edf6bf654061e8d"
    sha256 cellar: :any_skip_relocation, monterey:       "7139ae233008ce8431ecb9db7a8caa2613ee4e53cd1b0cd26b3f1c1408a2c124"
    sha256 cellar: :any_skip_relocation, big_sur:        "7139ae233008ce8431ecb9db7a8caa2613ee4e53cd1b0cd26b3f1c1408a2c124"
    sha256 cellar: :any_skip_relocation, catalina:       "7139ae233008ce8431ecb9db7a8caa2613ee4e53cd1b0cd26b3f1c1408a2c124"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "818d30946c9c390e69c79adb7d7de4392353b014eb73e38a8edf6bf654061e8d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".eslintrc.json").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")
    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end
