require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.34.0.tgz"
  sha256 "31d08f3541ab11ac8662302fd1a1a94f7e52df0c6edb32a63f129205f9335db9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99171c395a4de6fd9bf9225220671b88ed1dbd56c5a3238c13b805071bf178a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99171c395a4de6fd9bf9225220671b88ed1dbd56c5a3238c13b805071bf178a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99171c395a4de6fd9bf9225220671b88ed1dbd56c5a3238c13b805071bf178a7"
    sha256 cellar: :any_skip_relocation, ventura:        "42a13b7af46b9ba934bfa0915134a50890d2c5420e6007d0f74a15dc5a72fe43"
    sha256 cellar: :any_skip_relocation, monterey:       "42a13b7af46b9ba934bfa0915134a50890d2c5420e6007d0f74a15dc5a72fe43"
    sha256 cellar: :any_skip_relocation, big_sur:        "42a13b7af46b9ba934bfa0915134a50890d2c5420e6007d0f74a15dc5a72fe43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99171c395a4de6fd9bf9225220671b88ed1dbd56c5a3238c13b805071bf178a7"
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
