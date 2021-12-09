require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.4.1.tgz"
  sha256 "d75751e92d4d5b96d981ab902d667fe1b5bb31521c8155fa51dfad1553336ce8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cca15db1177ea56733133aa8b8d5265d6a4b483dca6fac56875e69d92bd0c51e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cca15db1177ea56733133aa8b8d5265d6a4b483dca6fac56875e69d92bd0c51e"
    sha256 cellar: :any_skip_relocation, monterey:       "7f89a271a691b4c6ae06f22c2349396407d175fc8ac772d567f5e63d104a65d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f89a271a691b4c6ae06f22c2349396407d175fc8ac772d567f5e63d104a65d0"
    sha256 cellar: :any_skip_relocation, catalina:       "7f89a271a691b4c6ae06f22c2349396407d175fc8ac772d567f5e63d104a65d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cca15db1177ea56733133aa8b8d5265d6a4b483dca6fac56875e69d92bd0c51e"
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
