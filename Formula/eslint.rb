require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.9.0.tgz"
  sha256 "df6cae949ca03a0297d2eebfb82d995aac13de5e7f911e17d36c2864f51e131f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "776d67115bdc563003b754964b43c2a7f95e843c418935d3dee385716c3389ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "776d67115bdc563003b754964b43c2a7f95e843c418935d3dee385716c3389ed"
    sha256 cellar: :any_skip_relocation, monterey:       "71373c4dc6e29101e2ab679fcff889b580ccb340e5f00285de79e5b77c1a632d"
    sha256 cellar: :any_skip_relocation, big_sur:        "71373c4dc6e29101e2ab679fcff889b580ccb340e5f00285de79e5b77c1a632d"
    sha256 cellar: :any_skip_relocation, catalina:       "71373c4dc6e29101e2ab679fcff889b580ccb340e5f00285de79e5b77c1a632d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "776d67115bdc563003b754964b43c2a7f95e843c418935d3dee385716c3389ed"
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
