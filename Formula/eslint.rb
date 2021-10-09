require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.0.0.tgz"
  sha256 "7d68c103198fb568a49ca1310c0c5ed728d18e0e8ed588999e4cfc54663fc834"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "da5caa31e9c4ceee02545ec6f805b6efc15d7047176d5654ec6a3a2122c06605"
    sha256 cellar: :any_skip_relocation, big_sur:       "cdf19a556e5809280db3c6a41685f92b2234834639609c69010f314c8dd1ad57"
    sha256 cellar: :any_skip_relocation, catalina:      "cdf19a556e5809280db3c6a41685f92b2234834639609c69010f314c8dd1ad57"
    sha256 cellar: :any_skip_relocation, mojave:        "cdf19a556e5809280db3c6a41685f92b2234834639609c69010f314c8dd1ad57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da5caa31e9c4ceee02545ec6f805b6efc15d7047176d5654ec6a3a2122c06605"
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
