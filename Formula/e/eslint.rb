require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.57.0.tgz"
  sha256 "97ec696de2427643aaa7cfa0478ea4fc8ef964c3b2fc9b1f4b57b5180629cf12"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e50b1b608690ddd93ea13fed459d32f199a023e4d6c4c2011e4e5737cd00176d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e50b1b608690ddd93ea13fed459d32f199a023e4d6c4c2011e4e5737cd00176d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e50b1b608690ddd93ea13fed459d32f199a023e4d6c4c2011e4e5737cd00176d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f78b23845fc25b6b6bed7896cd027b114b065d2532cd9387b9bed9242783a95a"
    sha256 cellar: :any_skip_relocation, ventura:        "f78b23845fc25b6b6bed7896cd027b114b065d2532cd9387b9bed9242783a95a"
    sha256 cellar: :any_skip_relocation, monterey:       "f78b23845fc25b6b6bed7896cd027b114b065d2532cd9387b9bed9242783a95a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e50b1b608690ddd93ea13fed459d32f199a023e4d6c4c2011e4e5737cd00176d"
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
