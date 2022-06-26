require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.18.0.tgz"
  sha256 "9047318809273f2538f1e0b32dd63b597ded6b478b54c8278767b2d0462ff3d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "798ab61a0a6254cce6ee0d87e54cee58666b9e0b83790adc7cd9f38c093aae24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "798ab61a0a6254cce6ee0d87e54cee58666b9e0b83790adc7cd9f38c093aae24"
    sha256 cellar: :any_skip_relocation, monterey:       "375cd9090646e1d1c14c6c452bb6cf21b2021b89539e815a9e8ddd5c50a5b66b"
    sha256 cellar: :any_skip_relocation, big_sur:        "375cd9090646e1d1c14c6c452bb6cf21b2021b89539e815a9e8ddd5c50a5b66b"
    sha256 cellar: :any_skip_relocation, catalina:       "375cd9090646e1d1c14c6c452bb6cf21b2021b89539e815a9e8ddd5c50a5b66b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "798ab61a0a6254cce6ee0d87e54cee58666b9e0b83790adc7cd9f38c093aae24"
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
