require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.15.0.tgz"
  sha256 "4025d206b3829e9c3b93464c67258047c431062c71a31e74e6328067c80304b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cc713c20d6086de20857c92f57bf23624fb144106572d4e21366630836d2324"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2cc713c20d6086de20857c92f57bf23624fb144106572d4e21366630836d2324"
    sha256 cellar: :any_skip_relocation, monterey:       "37ef1586c7df53c08138ef29a460fad9b9332bc19d6d1980a3e2a47ada57c574"
    sha256 cellar: :any_skip_relocation, big_sur:        "37ef1586c7df53c08138ef29a460fad9b9332bc19d6d1980a3e2a47ada57c574"
    sha256 cellar: :any_skip_relocation, catalina:       "37ef1586c7df53c08138ef29a460fad9b9332bc19d6d1980a3e2a47ada57c574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cc713c20d6086de20857c92f57bf23624fb144106572d4e21366630836d2324"
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
