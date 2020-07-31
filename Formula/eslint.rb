require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.6.0.tgz"
  sha256 "fd9968727fe5d616cf0d3a361a0c1f13294888ef2ddf9d8beac57d9842dce09e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b19c704b414b9c1c951935bf136afe697c179b30786007f73b6c3faba1e9d557" => :catalina
    sha256 "ec57d03d94e79bd17e069d2245ecc7cd1764d50d3ccc864d848acd8db5b38c7b" => :mojave
    sha256 "b4759a40ebe8d42993bdb7cc53f2d92509ff755393b406ad46f78eab3192df4f" => :high_sierra
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
