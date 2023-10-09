require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.51.0.tgz"
  sha256 "fd9b3904757a6dc6d8bff9cc212d18639d5172d23c20cf6f7bfae3a835f238e7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e17f13ab1fb8986c4dd3dcbd9ff84a3019a88004f8d920c35aa19f3411cfa30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e17f13ab1fb8986c4dd3dcbd9ff84a3019a88004f8d920c35aa19f3411cfa30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e17f13ab1fb8986c4dd3dcbd9ff84a3019a88004f8d920c35aa19f3411cfa30"
    sha256 cellar: :any_skip_relocation, sonoma:         "23d8907a722f3aec673c7419bd567a66ce86c3169c482b6b580bea620d166cf1"
    sha256 cellar: :any_skip_relocation, ventura:        "23d8907a722f3aec673c7419bd567a66ce86c3169c482b6b580bea620d166cf1"
    sha256 cellar: :any_skip_relocation, monterey:       "23d8907a722f3aec673c7419bd567a66ce86c3169c482b6b580bea620d166cf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e17f13ab1fb8986c4dd3dcbd9ff84a3019a88004f8d920c35aa19f3411cfa30"
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
