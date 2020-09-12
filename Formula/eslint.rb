require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.9.0.tgz"
  sha256 "b43e37bcaf278baecb6e01984e090387dd7309e6844a5851e5888b26bb51ed74"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1d0328062e73656b239eba8a1c178b0a7828ecb038a71bf6449c94b54ec9ccd4" => :catalina
    sha256 "000f9cdce913a2ff0b3aa0fea99575b23343e015b6682ea21e4d4dab382aab3f" => :mojave
    sha256 "f61dfa6a4a8f632cac9d43cf8a8972d0136927eab5098559a7babc49798ba2c0" => :high_sierra
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
