require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.19.0.tgz"
  sha256 "b1434965024dc1f475975fe4e5f10cad6e8cddf4dc356a910d1e1ee3b6af372b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fc214616d27283569421719f892967c23c263f90fb2e2dfd9f316635345a54b9"
    sha256 cellar: :any_skip_relocation, big_sur:       "7b9ae8b9c29f3dcf5b4277f5672dd0d9d35c25392105d37ba940545597edb695"
    sha256 cellar: :any_skip_relocation, catalina:      "9c32688cfba4b6d78b5abeeefe1e3f73802483479ec00e48d0a0dd2b92a46315"
    sha256 cellar: :any_skip_relocation, mojave:        "f3f89469e3534e605f17728352eb90849e986a6bfc9403ba55627ec00eb5f4c0"
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
