require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.36.0.tgz"
  sha256 "9dfc8f00d58ecab62fb9330a0d9269027ed0d21ec3ace17697cc595f60209b5a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f73e6c2c43610ec30743ece6863190dc613d2b8fc743364243bbfc8bc79a99be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f73e6c2c43610ec30743ece6863190dc613d2b8fc743364243bbfc8bc79a99be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f73e6c2c43610ec30743ece6863190dc613d2b8fc743364243bbfc8bc79a99be"
    sha256 cellar: :any_skip_relocation, ventura:        "0564bf224c1d60bd9c1789fe4579118a305b427d3ce874bc09c4120194961d6b"
    sha256 cellar: :any_skip_relocation, monterey:       "0564bf224c1d60bd9c1789fe4579118a305b427d3ce874bc09c4120194961d6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0564bf224c1d60bd9c1789fe4579118a305b427d3ce874bc09c4120194961d6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f73e6c2c43610ec30743ece6863190dc613d2b8fc743364243bbfc8bc79a99be"
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
