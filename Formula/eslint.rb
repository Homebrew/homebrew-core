require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.22.0.tgz"
  sha256 "3426e3200472e1088e7efc1bcca87fdc19572906fb038392e1d419a4f87984b9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9b0fdc8afbfa7d2bb86217c8c8cd003cc81f737b4d62c99dd2cfd8fb9320caca"
    sha256 cellar: :any_skip_relocation, big_sur:       "a554e0b8b8ba515425a87298ec942bff2dca6ecbde84a986f04671ba1ebc5419"
    sha256 cellar: :any_skip_relocation, catalina:      "4f51b1896ec9b882f119794a451f4f0efafc5587e3a55b96c14f58a0e6d9cbbb"
    sha256 cellar: :any_skip_relocation, mojave:        "244ed207ea838793369aa8f442a48020df32f4237f80a188c1a18a729bcaf3cf"
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
