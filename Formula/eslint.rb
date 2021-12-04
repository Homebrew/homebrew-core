require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.4.0.tgz"
  sha256 "9af1e7d5eae8666b8209277eea6591c941625163a9d53d4a5daa82fa7812d4ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5b06ef5166773a2ced68d2271fad53b9747dd3edfc6833eafa0c8efcfdb069e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5b06ef5166773a2ced68d2271fad53b9747dd3edfc6833eafa0c8efcfdb069e"
    sha256 cellar: :any_skip_relocation, monterey:       "1847ca55430c13936aee6e7a949662780590b6219d3796efd596cb4be4ddf766"
    sha256 cellar: :any_skip_relocation, big_sur:        "1847ca55430c13936aee6e7a949662780590b6219d3796efd596cb4be4ddf766"
    sha256 cellar: :any_skip_relocation, catalina:       "1847ca55430c13936aee6e7a949662780590b6219d3796efd596cb4be4ddf766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5b06ef5166773a2ced68d2271fad53b9747dd3edfc6833eafa0c8efcfdb069e"
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
