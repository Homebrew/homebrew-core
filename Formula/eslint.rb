require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.25.0.tgz"
  sha256 "916d705c88bc63605349cc1ca1bf5c14deaed7e9a8c239607532953df27e4f2d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08931357ad000ce3acfab753872c4fb24b0f6144c8d20f396037163f25a7fd43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08931357ad000ce3acfab753872c4fb24b0f6144c8d20f396037163f25a7fd43"
    sha256 cellar: :any_skip_relocation, monterey:       "579cc9b557bf5f08959d8386028dc3d9c03fbc77ee24059f88e3efb1c76aac28"
    sha256 cellar: :any_skip_relocation, big_sur:        "579cc9b557bf5f08959d8386028dc3d9c03fbc77ee24059f88e3efb1c76aac28"
    sha256 cellar: :any_skip_relocation, catalina:       "579cc9b557bf5f08959d8386028dc3d9c03fbc77ee24059f88e3efb1c76aac28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08931357ad000ce3acfab753872c4fb24b0f6144c8d20f396037163f25a7fd43"
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
